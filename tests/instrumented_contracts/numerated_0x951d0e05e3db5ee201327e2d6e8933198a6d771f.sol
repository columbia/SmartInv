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
216 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 // CAUTION
224 // This version of SafeMath should only be used with Solidity 0.8 or later,
225 // because it relies on the compiler's built in overflow checks.
226 
227 /**
228  * @dev Wrappers over Solidity's arithmetic operations.
229  *
230  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
231  * now has built in overflow checking.
232  */
233 library SafeMath {
234     /**
235      * @dev Returns the addition of two unsigned integers, with an overflow flag.
236      *
237      * _Available since v3.4._
238      */
239     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241             uint256 c = a + b;
242             if (c < a) return (false, 0);
243             return (true, c);
244         }
245     }
246 
247     /**
248      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
249      *
250      * _Available since v3.4._
251      */
252     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
253         unchecked {
254             if (b > a) return (false, 0);
255             return (true, a - b);
256         }
257     }
258 
259     /**
260      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
261      *
262      * _Available since v3.4._
263      */
264     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
265         unchecked {
266             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
267             // benefit is lost if 'b' is also tested.
268             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
269             if (a == 0) return (true, 0);
270             uint256 c = a * b;
271             if (c / a != b) return (false, 0);
272             return (true, c);
273         }
274     }
275 
276     /**
277      * @dev Returns the division of two unsigned integers, with a division by zero flag.
278      *
279      * _Available since v3.4._
280      */
281     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
282         unchecked {
283             if (b == 0) return (false, 0);
284             return (true, a / b);
285         }
286     }
287 
288     /**
289      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
290      *
291      * _Available since v3.4._
292      */
293     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         unchecked {
295             if (b == 0) return (false, 0);
296             return (true, a % b);
297         }
298     }
299 
300     /**
301      * @dev Returns the addition of two unsigned integers, reverting on
302      * overflow.
303      *
304      * Counterpart to Solidity's `+` operator.
305      *
306      * Requirements:
307      *
308      * - Addition cannot overflow.
309      */
310     function add(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a + b;
312     }
313 
314     /**
315      * @dev Returns the subtraction of two unsigned integers, reverting on
316      * overflow (when the result is negative).
317      *
318      * Counterpart to Solidity's `-` operator.
319      *
320      * Requirements:
321      *
322      * - Subtraction cannot overflow.
323      */
324     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a - b;
326     }
327 
328     /**
329      * @dev Returns the multiplication of two unsigned integers, reverting on
330      * overflow.
331      *
332      * Counterpart to Solidity's `*` operator.
333      *
334      * Requirements:
335      *
336      * - Multiplication cannot overflow.
337      */
338     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
339         return a * b;
340     }
341 
342     /**
343      * @dev Returns the integer division of two unsigned integers, reverting on
344      * division by zero. The result is rounded towards zero.
345      *
346      * Counterpart to Solidity's `/` operator.
347      *
348      * Requirements:
349      *
350      * - The divisor cannot be zero.
351      */
352     function div(uint256 a, uint256 b) internal pure returns (uint256) {
353         return a / b;
354     }
355 
356     /**
357      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
358      * reverting when dividing by zero.
359      *
360      * Counterpart to Solidity's `%` operator. This function uses a `revert`
361      * opcode (which leaves remaining gas untouched) while Solidity uses an
362      * invalid opcode to revert (consuming all remaining gas).
363      *
364      * Requirements:
365      *
366      * - The divisor cannot be zero.
367      */
368     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
369         return a % b;
370     }
371 
372     /**
373      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
374      * overflow (when the result is negative).
375      *
376      * CAUTION: This function is deprecated because it requires allocating memory for the error
377      * message unnecessarily. For custom revert reasons use {trySub}.
378      *
379      * Counterpart to Solidity's `-` operator.
380      *
381      * Requirements:
382      *
383      * - Subtraction cannot overflow.
384      */
385     function sub(
386         uint256 a,
387         uint256 b,
388         string memory errorMessage
389     ) internal pure returns (uint256) {
390         unchecked {
391             require(b <= a, errorMessage);
392             return a - b;
393         }
394     }
395 
396     /**
397      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
398      * division by zero. The result is rounded towards zero.
399      *
400      * Counterpart to Solidity's `/` operator. Note: this function uses a
401      * `revert` opcode (which leaves remaining gas untouched) while Solidity
402      * uses an invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function div(
409         uint256 a,
410         uint256 b,
411         string memory errorMessage
412     ) internal pure returns (uint256) {
413         unchecked {
414             require(b > 0, errorMessage);
415             return a / b;
416         }
417     }
418 
419     /**
420      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
421      * reverting with custom message when dividing by zero.
422      *
423      * CAUTION: This function is deprecated because it requires allocating memory for the error
424      * message unnecessarily. For custom revert reasons use {tryMod}.
425      *
426      * Counterpart to Solidity's `%` operator. This function uses a `revert`
427      * opcode (which leaves remaining gas untouched) while Solidity uses an
428      * invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      *
432      * - The divisor cannot be zero.
433      */
434     function mod(
435         uint256 a,
436         uint256 b,
437         string memory errorMessage
438     ) internal pure returns (uint256) {
439         unchecked {
440             require(b > 0, errorMessage);
441             return a % b;
442         }
443     }
444 }
445 
446 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Contract module that helps prevent reentrant calls to a function.
455  *
456  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
457  * available, which can be applied to functions to make sure there are no nested
458  * (reentrant) calls to them.
459  *
460  * Note that because there is a single `nonReentrant` guard, functions marked as
461  * `nonReentrant` may not call one another. This can be worked around by making
462  * those functions `private`, and then adding `external` `nonReentrant` entry
463  * points to them.
464  *
465  * TIP: If you would like to learn more about reentrancy and alternative ways
466  * to protect against it, check out our blog post
467  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
468  */
469 abstract contract ReentrancyGuard {
470     // Booleans are more expensive than uint256 or any type that takes up a full
471     // word because each write operation emits an extra SLOAD to first read the
472     // slot's contents, replace the bits taken up by the boolean, and then write
473     // back. This is the compiler's defense against contract upgrades and
474     // pointer aliasing, and it cannot be disabled.
475 
476     // The values being non-zero value makes deployment a bit more expensive,
477     // but in exchange the refund on every call to nonReentrant will be lower in
478     // amount. Since refunds are capped to a percentage of the total
479     // transaction's gas, it is best to keep them low in cases like this one, to
480     // increase the likelihood of the full refund coming into effect.
481     uint256 private constant _NOT_ENTERED = 1;
482     uint256 private constant _ENTERED = 2;
483 
484     uint256 private _status;
485 
486     constructor() {
487         _status = _NOT_ENTERED;
488     }
489 
490     /**
491      * @dev Prevents a contract from calling itself, directly or indirectly.
492      * Calling a `nonReentrant` function from another `nonReentrant`
493      * function is not supported. It is possible to prevent this from happening
494      * by making the `nonReentrant` function external, and making it call a
495      * `private` function that does the actual work.
496      */
497     modifier nonReentrant() {
498         // On the first call to nonReentrant, _notEntered will be true
499         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
500 
501         // Any calls to nonReentrant after this point will fail
502         _status = _ENTERED;
503 
504         _;
505 
506         // By storing the original value once again, a refund is triggered (see
507         // https://eips.ethereum.org/EIPS/eip-2200)
508         _status = _NOT_ENTERED;
509     }
510 }
511 
512 // File: @openzeppelin/contracts/utils/Strings.sol
513 
514 
515 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev String operations.
521  */
522 library Strings {
523     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
524     uint8 private constant _ADDRESS_LENGTH = 20;
525 
526     /**
527      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
528      */
529     function toString(uint256 value) internal pure returns (string memory) {
530         // Inspired by OraclizeAPI's implementation - MIT licence
531         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
532 
533         if (value == 0) {
534             return "0";
535         }
536         uint256 temp = value;
537         uint256 digits;
538         while (temp != 0) {
539             digits++;
540             temp /= 10;
541         }
542         bytes memory buffer = new bytes(digits);
543         while (value != 0) {
544             digits -= 1;
545             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
546             value /= 10;
547         }
548         return string(buffer);
549     }
550 
551     /**
552      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
553      */
554     function toHexString(uint256 value) internal pure returns (string memory) {
555         if (value == 0) {
556             return "0x00";
557         }
558         uint256 temp = value;
559         uint256 length = 0;
560         while (temp != 0) {
561             length++;
562             temp >>= 8;
563         }
564         return toHexString(value, length);
565     }
566 
567     /**
568      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
569      */
570     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
571         bytes memory buffer = new bytes(2 * length + 2);
572         buffer[0] = "0";
573         buffer[1] = "x";
574         for (uint256 i = 2 * length + 1; i > 1; --i) {
575             buffer[i] = _HEX_SYMBOLS[value & 0xf];
576             value >>= 4;
577         }
578         require(value == 0, "Strings: hex length insufficient");
579         return string(buffer);
580     }
581 
582     /**
583      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
584      */
585     function toHexString(address addr) internal pure returns (string memory) {
586         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
587     }
588 }
589 
590 // File: contracts/IERC721A.sol
591 
592 
593 // ERC721A Contracts v4.2.0
594 // Creator: Chiru Labs
595 
596 pragma solidity ^0.8.4;
597 
598 /**
599  * @dev Interface of ERC721A.
600  */
601 interface IERC721A {
602     /**
603      * The caller must own the token or be an approved operator.
604      */
605     error ApprovalCallerNotOwnerNorApproved();
606 
607     /**
608      * The token does not exist.
609      */
610     error ApprovalQueryForNonexistentToken();
611 
612     /**
613      * The caller cannot approve to their own address.
614      */
615     error ApproveToCaller();
616 
617     /**
618      * Cannot query the balance for the zero address.
619      */
620     error BalanceQueryForZeroAddress();
621 
622     /**
623      * Cannot mint to the zero address.
624      */
625     error MintToZeroAddress();
626 
627     /**
628      * The quantity of tokens minted must be more than zero.
629      */
630     error MintZeroQuantity();
631 
632     /**
633      * The token does not exist.
634      */
635     error OwnerQueryForNonexistentToken();
636 
637     /**
638      * The caller must own the token or be an approved operator.
639      */
640     error TransferCallerNotOwnerNorApproved();
641 
642     /**
643      * The token must be owned by `from`.
644      */
645     error TransferFromIncorrectOwner();
646 
647     /**
648      * Cannot safely transfer to a contract that does not implement the
649      * ERC721Receiver interface.
650      */
651     error TransferToNonERC721ReceiverImplementer();
652 
653     /**
654      * Cannot transfer to the zero address.
655      */
656     error TransferToZeroAddress();
657 
658     /**
659      * The token does not exist.
660      */
661     error URIQueryForNonexistentToken();
662 
663     /**
664      * The `quantity` minted with ERC2309 exceeds the safety limit.
665      */
666     error MintERC2309QuantityExceedsLimit();
667 
668     /**
669      * The `extraData` cannot be set on an unintialized ownership slot.
670      */
671     error OwnershipNotInitializedForExtraData();
672 
673     // =============================================================
674     //                            STRUCTS
675     // =============================================================
676 
677     struct TokenOwnership {
678         // The address of the owner.
679         address addr;
680         // Stores the start time of ownership with minimal overhead for tokenomics.
681         uint64 startTimestamp;
682         // Whether the token has been burned.
683         bool burned;
684         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
685         uint24 extraData;
686     }
687 
688     // =============================================================
689     //                         TOKEN COUNTERS
690     // =============================================================
691 
692     /**
693      * @dev Returns the total number of tokens in existence.
694      * Burned tokens will reduce the count.
695      * To get the total number of tokens minted, please see {_totalMinted}.
696      */
697     function totalSupply() external view returns (uint256);
698 
699     // =============================================================
700     //                            IERC165
701     // =============================================================
702 
703     /**
704      * @dev Returns true if this contract implements the interface defined by
705      * `interfaceId`. See the corresponding
706      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
707      * to learn more about how these ids are created.
708      *
709      * This function call must use less than 30000 gas.
710      */
711     function supportsInterface(bytes4 interfaceId) external view returns (bool);
712 
713     // =============================================================
714     //                            IERC721
715     // =============================================================
716 
717     /**
718      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
719      */
720     event Transfer(
721         address indexed from,
722         address indexed to,
723         uint256 indexed tokenId
724     );
725 
726     /**
727      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
728      */
729     event Approval(
730         address indexed owner,
731         address indexed approved,
732         uint256 indexed tokenId
733     );
734 
735     /**
736      * @dev Emitted when `owner` enables or disables
737      * (`approved`) `operator` to manage all of its assets.
738      */
739     event ApprovalForAll(
740         address indexed owner,
741         address indexed operator,
742         bool approved
743     );
744 
745     /**
746      * @dev Returns the number of tokens in `owner`'s account.
747      */
748     function balanceOf(address owner) external view returns (uint256 balance);
749 
750     /**
751      * @dev Returns the owner of the `tokenId` token.
752      *
753      * Requirements:
754      *
755      * - `tokenId` must exist.
756      */
757     function ownerOf(uint256 tokenId) external view returns (address owner);
758 
759     /**
760      * @dev Safely transfers `tokenId` token from `from` to `to`,
761      * checking first that contract recipients are aware of the ERC721 protocol
762      * to prevent tokens from being forever locked.
763      *
764      * Requirements:
765      *
766      * - `from` cannot be the zero address.
767      * - `to` cannot be the zero address.
768      * - `tokenId` token must exist and be owned by `from`.
769      * - If the caller is not `from`, it must be have been allowed to move
770      * this token by either {approve} or {setApprovalForAll}.
771      * - If `to` refers to a smart contract, it must implement
772      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
773      *
774      * Emits a {Transfer} event.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId,
780         bytes calldata data
781     ) external;
782 
783     /**
784      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
785      */
786     function safeTransferFrom(
787         address from,
788         address to,
789         uint256 tokenId
790     ) external;
791 
792     /**
793      * @dev Transfers `tokenId` from `from` to `to`.
794      *
795      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
796      * whenever possible.
797      *
798      * Requirements:
799      *
800      * - `from` cannot be the zero address.
801      * - `to` cannot be the zero address.
802      * - `tokenId` token must be owned by `from`.
803      * - If the caller is not `from`, it must be approved to move this token
804      * by either {approve} or {setApprovalForAll}.
805      *
806      * Emits a {Transfer} event.
807      */
808     function transferFrom(
809         address from,
810         address to,
811         uint256 tokenId
812     ) external;
813 
814     /**
815      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
816      * The approval is cleared when the token is transferred.
817      *
818      * Only a single account can be approved at a time, so approving the
819      * zero address clears previous approvals.
820      *
821      * Requirements:
822      *
823      * - The caller must own the token or be an approved operator.
824      * - `tokenId` must exist.
825      *
826      * Emits an {Approval} event.
827      */
828     function approve(address to, uint256 tokenId) external;
829 
830     /**
831      * @dev Approve or remove `operator` as an operator for the caller.
832      * Operators can call {transferFrom} or {safeTransferFrom}
833      * for any token owned by the caller.
834      *
835      * Requirements:
836      *
837      * - The `operator` cannot be the caller.
838      *
839      * Emits an {ApprovalForAll} event.
840      */
841     function setApprovalForAll(address operator, bool _approved) external;
842 
843     /**
844      * @dev Returns the account approved for `tokenId` token.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must exist.
849      */
850     function getApproved(uint256 tokenId)
851         external
852         view
853         returns (address operator);
854 
855     /**
856      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
857      *
858      * See {setApprovalForAll}.
859      */
860     function isApprovedForAll(address owner, address operator)
861         external
862         view
863         returns (bool);
864 
865     // =============================================================
866     //                        IERC721Metadata
867     // =============================================================
868 
869     /**
870      * @dev Returns the token collection name.
871      */
872     function name() external view returns (string memory);
873 
874     /**
875      * @dev Returns the token collection symbol.
876      */
877     function symbol() external view returns (string memory);
878 
879     /**
880      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
881      */
882     function tokenURI(uint256 tokenId) external view returns (string memory);
883 
884     // =============================================================
885     //                           IERC2309
886     // =============================================================
887 
888     /**
889      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
890      * (inclusive) is transferred from `from` to `to`, as defined in the
891      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
892      *
893      * See {_mintERC2309} for more details.
894      */
895     event ConsecutiveTransfer(
896         uint256 indexed fromTokenId,
897         uint256 toTokenId,
898         address indexed from,
899         address indexed to
900     );
901 }
902 
903 // File: contracts/ERC721A.sol
904 
905 
906 // ERC721A Contracts v4.2.0
907 // Creator: Chiru Labs
908 
909 pragma solidity ^0.8.4;
910 
911 
912 /**
913  * @dev Interface of ERC721 token receiver.
914  */
915 interface ERC721A__IERC721Receiver {
916     function onERC721Received(
917         address operator,
918         address from,
919         uint256 tokenId,
920         bytes calldata data
921     ) external returns (bytes4);
922 }
923 
924 /**
925  * @title ERC721A
926  *
927  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
928  * Non-Fungible Token Standard, including the Metadata extension.
929  * Optimized for lower gas during batch mints.
930  *
931  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
932  * starting from `_startTokenId()`.
933  *
934  * Assumptions:
935  *
936  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
937  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
938  */
939 contract ERC721A is IERC721A {
940     // Reference type for token approval.
941     struct TokenApprovalRef {
942         address value;
943     }
944 
945     // =============================================================
946     //                           CONSTANTS
947     // =============================================================
948 
949     // Mask of an entry in packed address data.
950     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
951 
952     // The bit position of `numberMinted` in packed address data.
953     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
954 
955     // The bit position of `numberBurned` in packed address data.
956     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
957 
958     // The bit position of `aux` in packed address data.
959     uint256 private constant _BITPOS_AUX = 192;
960 
961     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
962     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
963 
964     // The bit position of `startTimestamp` in packed ownership.
965     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
966 
967     // The bit mask of the `burned` bit in packed ownership.
968     uint256 private constant _BITMASK_BURNED = 1 << 224;
969 
970     // The bit position of the `nextInitialized` bit in packed ownership.
971     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
972 
973     // The bit mask of the `nextInitialized` bit in packed ownership.
974     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
975 
976     // The bit position of `extraData` in packed ownership.
977     uint256 private constant _BITPOS_EXTRA_DATA = 232;
978 
979     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
980     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
981 
982     // The mask of the lower 160 bits for addresses.
983     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
984 
985     // The maximum `quantity` that can be minted with {_mintERC2309}.
986     // This limit is to prevent overflows on the address data entries.
987     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
988     // is required to cause an overflow, which is unrealistic.
989     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
990 
991     // The `Transfer` event signature is given by:
992     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
993     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
994         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
995 
996     // =============================================================
997     //                            STORAGE
998     // =============================================================
999 
1000     // The next token ID to be minted.
1001     uint256 private _currentIndex;
1002 
1003     // The number of tokens burned.
1004     uint256 private _burnCounter;
1005 
1006     // Token name
1007     string private _name;
1008 
1009     // Token symbol
1010     string private _symbol;
1011 
1012     // Mapping from token ID to ownership details
1013     // An empty struct value does not necessarily mean the token is unowned.
1014     // See {_packedOwnershipOf} implementation for details.
1015     //
1016     // Bits Layout:
1017     // - [0..159]   `addr`
1018     // - [160..223] `startTimestamp`
1019     // - [224]      `burned`
1020     // - [225]      `nextInitialized`
1021     // - [232..255] `extraData`
1022     mapping(uint256 => uint256) private _packedOwnerships;
1023 
1024     // Mapping owner address to address data.
1025     //
1026     // Bits Layout:
1027     // - [0..63]    `balance`
1028     // - [64..127]  `numberMinted`
1029     // - [128..191] `numberBurned`
1030     // - [192..255] `aux`
1031     mapping(address => uint256) private _packedAddressData;
1032 
1033     // Mapping from token ID to approved address.
1034     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1035 
1036     // Mapping from owner to operator approvals
1037     mapping(address => mapping(address => bool)) private _operatorApprovals;
1038 
1039     // =============================================================
1040     //                          CONSTRUCTOR
1041     // =============================================================
1042 
1043     constructor(string memory name_, string memory symbol_) {
1044         _name = name_;
1045         _symbol = symbol_;
1046         _currentIndex = _startTokenId();
1047     }
1048 
1049     // =============================================================
1050     //                   TOKEN COUNTING OPERATIONS
1051     // =============================================================
1052 
1053     /**
1054      * @dev Returns the starting token ID.
1055      * To change the starting token ID, please override this function.
1056      */
1057     function _startTokenId() internal view virtual returns (uint256) {
1058         return 0;
1059     }
1060 
1061     /**
1062      * @dev Returns the next token ID to be minted.
1063      */
1064     function _nextTokenId() internal view virtual returns (uint256) {
1065         return _currentIndex;
1066     }
1067 
1068     /**
1069      * @dev Returns the total number of tokens in existence.
1070      * Burned tokens will reduce the count.
1071      * To get the total number of tokens minted, please see {_totalMinted}.
1072      */
1073     function totalSupply() public view virtual override returns (uint256) {
1074         // Counter underflow is impossible as _burnCounter cannot be incremented
1075         // more than `_currentIndex - _startTokenId()` times.
1076         unchecked {
1077             return _currentIndex - _burnCounter - _startTokenId();
1078         }
1079     }
1080 
1081     /**
1082      * @dev Returns the total amount of tokens minted in the contract.
1083      */
1084     function _totalMinted() internal view virtual returns (uint256) {
1085         // Counter underflow is impossible as `_currentIndex` does not decrement,
1086         // and it is initialized to `_startTokenId()`.
1087         unchecked {
1088             return _currentIndex - _startTokenId();
1089         }
1090     }
1091 
1092     /**
1093      * @dev Returns the total number of tokens burned.
1094      */
1095     function _totalBurned() internal view virtual returns (uint256) {
1096         return _burnCounter;
1097     }
1098 
1099     // =============================================================
1100     //                    ADDRESS DATA OPERATIONS
1101     // =============================================================
1102 
1103     /**
1104      * @dev Returns the number of tokens in `owner`'s account.
1105      */
1106     function balanceOf(address owner) public view virtual override returns (uint256) {
1107         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1108         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1109     }
1110 
1111     /**
1112      * Returns the number of tokens minted by `owner`.
1113      */
1114     function _numberMinted(address owner) internal view returns (uint256) {
1115         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1116     }
1117 
1118     /**
1119      * Returns the number of tokens burned by or on behalf of `owner`.
1120      */
1121     function _numberBurned(address owner) internal view returns (uint256) {
1122         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1123     }
1124 
1125     /**
1126      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1127      */
1128     function _getAux(address owner) internal view returns (uint64) {
1129         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1130     }
1131 
1132     /**
1133      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1134      * If there are multiple variables, please pack them into a uint64.
1135      */
1136     function _setAux(address owner, uint64 aux) internal virtual {
1137         uint256 packed = _packedAddressData[owner];
1138         uint256 auxCasted;
1139         // Cast `aux` with assembly to avoid redundant masking.
1140         assembly {
1141             auxCasted := aux
1142         }
1143         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1144         _packedAddressData[owner] = packed;
1145     }
1146 
1147     // =============================================================
1148     //                            IERC165
1149     // =============================================================
1150 
1151     /**
1152      * @dev Returns true if this contract implements the interface defined by
1153      * `interfaceId`. See the corresponding
1154      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1155      * to learn more about how these ids are created.
1156      *
1157      * This function call must use less than 30000 gas.
1158      */
1159     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1160         // The interface IDs are constants representing the first 4 bytes
1161         // of the XOR of all function selectors in the interface.
1162         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1163         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1164         return
1165             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1166             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1167             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1168     }
1169 
1170     // =============================================================
1171     //                        IERC721Metadata
1172     // =============================================================
1173 
1174     /**
1175      * @dev Returns the token collection name.
1176      */
1177     function name() public view virtual override returns (string memory) {
1178         return _name;
1179     }
1180 
1181     /**
1182      * @dev Returns the token collection symbol.
1183      */
1184     function symbol() public view virtual override returns (string memory) {
1185         return _symbol;
1186     }
1187 
1188     /**
1189      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1190      */
1191     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1192         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1193 
1194         string memory baseURI = _baseURI();
1195         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1196     }
1197 
1198     /**
1199      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1200      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1201      * by default, it can be overridden in child contracts.
1202      */
1203     function _baseURI() internal view virtual returns (string memory) {
1204         return '';
1205     }
1206 
1207     // =============================================================
1208     //                     OWNERSHIPS OPERATIONS
1209     // =============================================================
1210 
1211     /**
1212      * @dev Returns the owner of the `tokenId` token.
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must exist.
1217      */
1218     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1219         return address(uint160(_packedOwnershipOf(tokenId)));
1220     }
1221 
1222     /**
1223      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1224      * It gradually moves to O(1) as tokens get transferred around over time.
1225      */
1226     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1227         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1228     }
1229 
1230     /**
1231      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1232      */
1233     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1234         return _unpackedOwnership(_packedOwnerships[index]);
1235     }
1236 
1237     /**
1238      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1239      */
1240     function _initializeOwnershipAt(uint256 index) internal virtual {
1241         if (_packedOwnerships[index] == 0) {
1242             _packedOwnerships[index] = _packedOwnershipOf(index);
1243         }
1244     }
1245 
1246     /**
1247      * Returns the packed ownership data of `tokenId`.
1248      */
1249     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1250         uint256 curr = tokenId;
1251 
1252         unchecked {
1253             if (_startTokenId() <= curr)
1254                 if (curr < _currentIndex) {
1255                     uint256 packed = _packedOwnerships[curr];
1256                     // If not burned.
1257                     if (packed & _BITMASK_BURNED == 0) {
1258                         // Invariant:
1259                         // There will always be an initialized ownership slot
1260                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1261                         // before an unintialized ownership slot
1262                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1263                         // Hence, `curr` will not underflow.
1264                         //
1265                         // We can directly compare the packed value.
1266                         // If the address is zero, packed will be zero.
1267                         while (packed == 0) {
1268                             packed = _packedOwnerships[--curr];
1269                         }
1270                         return packed;
1271                     }
1272                 }
1273         }
1274         revert OwnerQueryForNonexistentToken();
1275     }
1276 
1277     /**
1278      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1279      */
1280     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1281         ownership.addr = address(uint160(packed));
1282         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1283         ownership.burned = packed & _BITMASK_BURNED != 0;
1284         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1285     }
1286 
1287     /**
1288      * @dev Packs ownership data into a single uint256.
1289      */
1290     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1291         assembly {
1292             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1293             owner := and(owner, _BITMASK_ADDRESS)
1294             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1295             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1296         }
1297     }
1298 
1299     /**
1300      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1301      */
1302     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1303         // For branchless setting of the `nextInitialized` flag.
1304         assembly {
1305             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1306             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1307         }
1308     }
1309 
1310     // =============================================================
1311     //                      APPROVAL OPERATIONS
1312     // =============================================================
1313 
1314     /**
1315      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1316      * The approval is cleared when the token is transferred.
1317      *
1318      * Only a single account can be approved at a time, so approving the
1319      * zero address clears previous approvals.
1320      *
1321      * Requirements:
1322      *
1323      * - The caller must own the token or be an approved operator.
1324      * - `tokenId` must exist.
1325      *
1326      * Emits an {Approval} event.
1327      */
1328     function approve(address to, uint256 tokenId) public virtual override {
1329         address owner = ownerOf(tokenId);
1330 
1331         if (_msgSenderERC721A() != owner)
1332             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1333                 revert ApprovalCallerNotOwnerNorApproved();
1334             }
1335 
1336         _tokenApprovals[tokenId].value = to;
1337         emit Approval(owner, to, tokenId);
1338     }
1339 
1340     /**
1341      * @dev Returns the account approved for `tokenId` token.
1342      *
1343      * Requirements:
1344      *
1345      * - `tokenId` must exist.
1346      */
1347     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1348         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1349 
1350         return _tokenApprovals[tokenId].value;
1351     }
1352 
1353     /**
1354      * @dev Approve or remove `operator` as an operator for the caller.
1355      * Operators can call {transferFrom} or {safeTransferFrom}
1356      * for any token owned by the caller.
1357      *
1358      * Requirements:
1359      *
1360      * - The `operator` cannot be the caller.
1361      *
1362      * Emits an {ApprovalForAll} event.
1363      */
1364     function setApprovalForAll(address operator, bool approved) public virtual override {
1365         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1366 
1367         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1368         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1369     }
1370 
1371     /**
1372      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1373      *
1374      * See {setApprovalForAll}.
1375      */
1376     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1377         return _operatorApprovals[owner][operator];
1378     }
1379 
1380     /**
1381      * @dev Returns whether `tokenId` exists.
1382      *
1383      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1384      *
1385      * Tokens start existing when they are minted. See {_mint}.
1386      */
1387     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1388         return
1389             _startTokenId() <= tokenId &&
1390             tokenId < _currentIndex && // If within bounds,
1391             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1392     }
1393 
1394     /**
1395      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1396      */
1397     function _isSenderApprovedOrOwner(
1398         address approvedAddress,
1399         address owner,
1400         address msgSender
1401     ) private pure returns (bool result) {
1402         assembly {
1403             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1404             owner := and(owner, _BITMASK_ADDRESS)
1405             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1406             msgSender := and(msgSender, _BITMASK_ADDRESS)
1407             // `msgSender == owner || msgSender == approvedAddress`.
1408             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1409         }
1410     }
1411 
1412     /**
1413      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1414      */
1415     function _getApprovedSlotAndAddress(uint256 tokenId)
1416         private
1417         view
1418         returns (uint256 approvedAddressSlot, address approvedAddress)
1419     {
1420         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1421         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1422         assembly {
1423             approvedAddressSlot := tokenApproval.slot
1424             approvedAddress := sload(approvedAddressSlot)
1425         }
1426     }
1427 
1428     // =============================================================
1429     //                      TRANSFER OPERATIONS
1430     // =============================================================
1431 
1432     /**
1433      * @dev Transfers `tokenId` from `from` to `to`.
1434      *
1435      * Requirements:
1436      *
1437      * - `from` cannot be the zero address.
1438      * - `to` cannot be the zero address.
1439      * - `tokenId` token must be owned by `from`.
1440      * - If the caller is not `from`, it must be approved to move this token
1441      * by either {approve} or {setApprovalForAll}.
1442      *
1443      * Emits a {Transfer} event.
1444      */
1445     function transferFrom(
1446         address from,
1447         address to,
1448         uint256 tokenId
1449     ) public virtual override {
1450         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1451 
1452         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1453 
1454         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1455 
1456         // The nested ifs save around 20+ gas over a compound boolean condition.
1457         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1458             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1459 
1460         if (to == address(0)) revert TransferToZeroAddress();
1461 
1462         _beforeTokenTransfers(from, to, tokenId, 1);
1463 
1464         // Clear approvals from the previous owner.
1465         assembly {
1466             if approvedAddress {
1467                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1468                 sstore(approvedAddressSlot, 0)
1469             }
1470         }
1471 
1472         // Underflow of the sender's balance is impossible because we check for
1473         // ownership above and the recipient's balance can't realistically overflow.
1474         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1475         unchecked {
1476             // We can directly increment and decrement the balances.
1477             --_packedAddressData[from]; // Updates: `balance -= 1`.
1478             ++_packedAddressData[to]; // Updates: `balance += 1`.
1479 
1480             // Updates:
1481             // - `address` to the next owner.
1482             // - `startTimestamp` to the timestamp of transfering.
1483             // - `burned` to `false`.
1484             // - `nextInitialized` to `true`.
1485             _packedOwnerships[tokenId] = _packOwnershipData(
1486                 to,
1487                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1488             );
1489 
1490             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1491             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1492                 uint256 nextTokenId = tokenId + 1;
1493                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1494                 if (_packedOwnerships[nextTokenId] == 0) {
1495                     // If the next slot is within bounds.
1496                     if (nextTokenId != _currentIndex) {
1497                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1498                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1499                     }
1500                 }
1501             }
1502         }
1503 
1504         emit Transfer(from, to, tokenId);
1505         _afterTokenTransfers(from, to, tokenId, 1);
1506     }
1507 
1508     /**
1509      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1510      */
1511     function safeTransferFrom(
1512         address from,
1513         address to,
1514         uint256 tokenId
1515     ) public virtual override {
1516         safeTransferFrom(from, to, tokenId, '');
1517     }
1518 
1519     /**
1520      * @dev Safely transfers `tokenId` token from `from` to `to`.
1521      *
1522      * Requirements:
1523      *
1524      * - `from` cannot be the zero address.
1525      * - `to` cannot be the zero address.
1526      * - `tokenId` token must exist and be owned by `from`.
1527      * - If the caller is not `from`, it must be approved to move this token
1528      * by either {approve} or {setApprovalForAll}.
1529      * - If `to` refers to a smart contract, it must implement
1530      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1531      *
1532      * Emits a {Transfer} event.
1533      */
1534     function safeTransferFrom(
1535         address from,
1536         address to,
1537         uint256 tokenId,
1538         bytes memory _data
1539     ) public virtual override {
1540         transferFrom(from, to, tokenId);
1541         if (to.code.length != 0)
1542             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1543                 revert TransferToNonERC721ReceiverImplementer();
1544             }
1545     }
1546 
1547     /**
1548      * @dev Hook that is called before a set of serially-ordered token IDs
1549      * are about to be transferred. This includes minting.
1550      * And also called before burning one token.
1551      *
1552      * `startTokenId` - the first token ID to be transferred.
1553      * `quantity` - the amount to be transferred.
1554      *
1555      * Calling conditions:
1556      *
1557      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1558      * transferred to `to`.
1559      * - When `from` is zero, `tokenId` will be minted for `to`.
1560      * - When `to` is zero, `tokenId` will be burned by `from`.
1561      * - `from` and `to` are never both zero.
1562      */
1563     function _beforeTokenTransfers(
1564         address from,
1565         address to,
1566         uint256 startTokenId,
1567         uint256 quantity
1568     ) internal virtual {}
1569 
1570     /**
1571      * @dev Hook that is called after a set of serially-ordered token IDs
1572      * have been transferred. This includes minting.
1573      * And also called after one token has been burned.
1574      *
1575      * `startTokenId` - the first token ID to be transferred.
1576      * `quantity` - the amount to be transferred.
1577      *
1578      * Calling conditions:
1579      *
1580      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1581      * transferred to `to`.
1582      * - When `from` is zero, `tokenId` has been minted for `to`.
1583      * - When `to` is zero, `tokenId` has been burned by `from`.
1584      * - `from` and `to` are never both zero.
1585      */
1586     function _afterTokenTransfers(
1587         address from,
1588         address to,
1589         uint256 startTokenId,
1590         uint256 quantity
1591     ) internal virtual {}
1592 
1593     /**
1594      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1595      *
1596      * `from` - Previous owner of the given token ID.
1597      * `to` - Target address that will receive the token.
1598      * `tokenId` - Token ID to be transferred.
1599      * `_data` - Optional data to send along with the call.
1600      *
1601      * Returns whether the call correctly returned the expected magic value.
1602      */
1603     function _checkContractOnERC721Received(
1604         address from,
1605         address to,
1606         uint256 tokenId,
1607         bytes memory _data
1608     ) private returns (bool) {
1609         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1610             bytes4 retval
1611         ) {
1612             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1613         } catch (bytes memory reason) {
1614             if (reason.length == 0) {
1615                 revert TransferToNonERC721ReceiverImplementer();
1616             } else {
1617                 assembly {
1618                     revert(add(32, reason), mload(reason))
1619                 }
1620             }
1621         }
1622     }
1623 
1624     // =============================================================
1625     //                        MINT OPERATIONS
1626     // =============================================================
1627 
1628     /**
1629      * @dev Mints `quantity` tokens and transfers them to `to`.
1630      *
1631      * Requirements:
1632      *
1633      * - `to` cannot be the zero address.
1634      * - `quantity` must be greater than 0.
1635      *
1636      * Emits a {Transfer} event for each mint.
1637      */
1638     function _mint(address to, uint256 quantity) internal virtual {
1639         uint256 startTokenId = _currentIndex;
1640         if (quantity == 0) revert MintZeroQuantity();
1641 
1642         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1643 
1644         // Overflows are incredibly unrealistic.
1645         // `balance` and `numberMinted` have a maximum limit of 2**64.
1646         // `tokenId` has a maximum limit of 2**256.
1647         unchecked {
1648             // Updates:
1649             // - `balance += quantity`.
1650             // - `numberMinted += quantity`.
1651             //
1652             // We can directly add to the `balance` and `numberMinted`.
1653             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1654 
1655             // Updates:
1656             // - `address` to the owner.
1657             // - `startTimestamp` to the timestamp of minting.
1658             // - `burned` to `false`.
1659             // - `nextInitialized` to `quantity == 1`.
1660             _packedOwnerships[startTokenId] = _packOwnershipData(
1661                 to,
1662                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1663             );
1664 
1665             uint256 toMasked;
1666             uint256 end = startTokenId + quantity;
1667 
1668             // Use assembly to loop and emit the `Transfer` event for gas savings.
1669             assembly {
1670                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1671                 toMasked := and(to, _BITMASK_ADDRESS)
1672                 // Emit the `Transfer` event.
1673                 log4(
1674                     0, // Start of data (0, since no data).
1675                     0, // End of data (0, since no data).
1676                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1677                     0, // `address(0)`.
1678                     toMasked, // `to`.
1679                     startTokenId // `tokenId`.
1680                 )
1681 
1682                 for {
1683                     let tokenId := add(startTokenId, 1)
1684                 } iszero(eq(tokenId, end)) {
1685                     tokenId := add(tokenId, 1)
1686                 } {
1687                     // Emit the `Transfer` event. Similar to above.
1688                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1689                 }
1690             }
1691             if (toMasked == 0) revert MintToZeroAddress();
1692 
1693             _currentIndex = end;
1694         }
1695         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1696     }
1697 
1698     /**
1699      * @dev Mints `quantity` tokens and transfers them to `to`.
1700      *
1701      * This function is intended for efficient minting only during contract creation.
1702      *
1703      * It emits only one {ConsecutiveTransfer} as defined in
1704      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1705      * instead of a sequence of {Transfer} event(s).
1706      *
1707      * Calling this function outside of contract creation WILL make your contract
1708      * non-compliant with the ERC721 standard.
1709      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1710      * {ConsecutiveTransfer} event is only permissible during contract creation.
1711      *
1712      * Requirements:
1713      *
1714      * - `to` cannot be the zero address.
1715      * - `quantity` must be greater than 0.
1716      *
1717      * Emits a {ConsecutiveTransfer} event.
1718      */
1719     function _mintERC2309(address to, uint256 quantity) internal virtual {
1720         uint256 startTokenId = _currentIndex;
1721         if (to == address(0)) revert MintToZeroAddress();
1722         if (quantity == 0) revert MintZeroQuantity();
1723         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1724 
1725         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1726 
1727         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1728         unchecked {
1729             // Updates:
1730             // - `balance += quantity`.
1731             // - `numberMinted += quantity`.
1732             //
1733             // We can directly add to the `balance` and `numberMinted`.
1734             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1735 
1736             // Updates:
1737             // - `address` to the owner.
1738             // - `startTimestamp` to the timestamp of minting.
1739             // - `burned` to `false`.
1740             // - `nextInitialized` to `quantity == 1`.
1741             _packedOwnerships[startTokenId] = _packOwnershipData(
1742                 to,
1743                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1744             );
1745 
1746             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1747 
1748             _currentIndex = startTokenId + quantity;
1749         }
1750         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1751     }
1752 
1753     /**
1754      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1755      *
1756      * Requirements:
1757      *
1758      * - If `to` refers to a smart contract, it must implement
1759      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1760      * - `quantity` must be greater than 0.
1761      *
1762      * See {_mint}.
1763      *
1764      * Emits a {Transfer} event for each mint.
1765      */
1766     function _safeMint(
1767         address to,
1768         uint256 quantity,
1769         bytes memory _data
1770     ) internal virtual {
1771         _mint(to, quantity);
1772 
1773         unchecked {
1774             if (to.code.length != 0) {
1775                 uint256 end = _currentIndex;
1776                 uint256 index = end - quantity;
1777                 do {
1778                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1779                         revert TransferToNonERC721ReceiverImplementer();
1780                     }
1781                 } while (index < end);
1782                 // Reentrancy protection.
1783                 if (_currentIndex != end) revert();
1784             }
1785         }
1786     }
1787 
1788     /**
1789      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1790      */
1791     function _safeMint(address to, uint256 quantity) internal virtual {
1792         _safeMint(to, quantity, '');
1793     }
1794 
1795     // =============================================================
1796     //                        BURN OPERATIONS
1797     // =============================================================
1798 
1799     /**
1800      * @dev Equivalent to `_burn(tokenId, false)`.
1801      */
1802     function _burn(uint256 tokenId) internal virtual {
1803         _burn(tokenId, false);
1804     }
1805 
1806     /**
1807      * @dev Destroys `tokenId`.
1808      * The approval is cleared when the token is burned.
1809      *
1810      * Requirements:
1811      *
1812      * - `tokenId` must exist.
1813      *
1814      * Emits a {Transfer} event.
1815      */
1816     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1817         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1818 
1819         address from = address(uint160(prevOwnershipPacked));
1820 
1821         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1822 
1823         if (approvalCheck) {
1824             // The nested ifs save around 20+ gas over a compound boolean condition.
1825             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1826                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1827         }
1828 
1829         _beforeTokenTransfers(from, address(0), tokenId, 1);
1830 
1831         // Clear approvals from the previous owner.
1832         assembly {
1833             if approvedAddress {
1834                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1835                 sstore(approvedAddressSlot, 0)
1836             }
1837         }
1838 
1839         // Underflow of the sender's balance is impossible because we check for
1840         // ownership above and the recipient's balance can't realistically overflow.
1841         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1842         unchecked {
1843             // Updates:
1844             // - `balance -= 1`.
1845             // - `numberBurned += 1`.
1846             //
1847             // We can directly decrement the balance, and increment the number burned.
1848             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1849             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1850 
1851             // Updates:
1852             // - `address` to the last owner.
1853             // - `startTimestamp` to the timestamp of burning.
1854             // - `burned` to `true`.
1855             // - `nextInitialized` to `true`.
1856             _packedOwnerships[tokenId] = _packOwnershipData(
1857                 from,
1858                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1859             );
1860 
1861             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1862             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1863                 uint256 nextTokenId = tokenId + 1;
1864                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1865                 if (_packedOwnerships[nextTokenId] == 0) {
1866                     // If the next slot is within bounds.
1867                     if (nextTokenId != _currentIndex) {
1868                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1869                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1870                     }
1871                 }
1872             }
1873         }
1874 
1875         emit Transfer(from, address(0), tokenId);
1876         _afterTokenTransfers(from, address(0), tokenId, 1);
1877 
1878         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1879         unchecked {
1880             _burnCounter++;
1881         }
1882     }
1883 
1884     // =============================================================
1885     //                     EXTRA DATA OPERATIONS
1886     // =============================================================
1887 
1888     /**
1889      * @dev Directly sets the extra data for the ownership data `index`.
1890      */
1891     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1892         uint256 packed = _packedOwnerships[index];
1893         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1894         uint256 extraDataCasted;
1895         // Cast `extraData` with assembly to avoid redundant masking.
1896         assembly {
1897             extraDataCasted := extraData
1898         }
1899         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1900         _packedOwnerships[index] = packed;
1901     }
1902 
1903     /**
1904      * @dev Called during each token transfer to set the 24bit `extraData` field.
1905      * Intended to be overridden by the cosumer contract.
1906      *
1907      * `previousExtraData` - the value of `extraData` before transfer.
1908      *
1909      * Calling conditions:
1910      *
1911      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1912      * transferred to `to`.
1913      * - When `from` is zero, `tokenId` will be minted for `to`.
1914      * - When `to` is zero, `tokenId` will be burned by `from`.
1915      * - `from` and `to` are never both zero.
1916      */
1917     function _extraData(
1918         address from,
1919         address to,
1920         uint24 previousExtraData
1921     ) internal view virtual returns (uint24) {}
1922 
1923     /**
1924      * @dev Returns the next extra data for the packed ownership data.
1925      * The returned result is shifted into position.
1926      */
1927     function _nextExtraData(
1928         address from,
1929         address to,
1930         uint256 prevOwnershipPacked
1931     ) private view returns (uint256) {
1932         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1933         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1934     }
1935 
1936     // =============================================================
1937     //                       OTHER OPERATIONS
1938     // =============================================================
1939 
1940     /**
1941      * @dev Returns the message sender (defaults to `msg.sender`).
1942      *
1943      * If you are writing GSN compatible contracts, you need to override this function.
1944      */
1945     function _msgSenderERC721A() internal view virtual returns (address) {
1946         return msg.sender;
1947     }
1948 
1949     /**
1950      * @dev Converts a uint256 to its ASCII string decimal representation.
1951      */
1952     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1953         assembly {
1954             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1955             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1956             // We will need 1 32-byte word to store the length,
1957             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1958             ptr := add(mload(0x40), 128)
1959             // Update the free memory pointer to allocate.
1960             mstore(0x40, ptr)
1961 
1962             // Cache the end of the memory to calculate the length later.
1963             let end := ptr
1964 
1965             // We write the string from the rightmost digit to the leftmost digit.
1966             // The following is essentially a do-while loop that also handles the zero case.
1967             // Costs a bit more than early returning for the zero case,
1968             // but cheaper in terms of deployment and overall runtime costs.
1969             for {
1970                 // Initialize and perform the first pass without check.
1971                 let temp := value
1972                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1973                 ptr := sub(ptr, 1)
1974                 // Write the character to the pointer.
1975                 // The ASCII index of the '0' character is 48.
1976                 mstore8(ptr, add(48, mod(temp, 10)))
1977                 temp := div(temp, 10)
1978             } temp {
1979                 // Keep dividing `temp` until zero.
1980                 temp := div(temp, 10)
1981             } {
1982                 // Body of the for loop.
1983                 ptr := sub(ptr, 1)
1984                 mstore8(ptr, add(48, mod(temp, 10)))
1985             }
1986 
1987             let length := sub(end, ptr)
1988             // Move the pointer 32 bytes leftwards to make room for the length.
1989             ptr := sub(ptr, 32)
1990             // Store the length.
1991             mstore(ptr, length)
1992         }
1993     }
1994 }
1995 // File: @openzeppelin/contracts/utils/Context.sol
1996 
1997 
1998 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1999 
2000 pragma solidity ^0.8.0;
2001 
2002 /**
2003  * @dev Provides information about the current execution context, including the
2004  * sender of the transaction and its data. While these are generally available
2005  * via msg.sender and msg.data, they should not be accessed in such a direct
2006  * manner, since when dealing with meta-transactions the account sending and
2007  * paying for execution may not be the actual sender (as far as an application
2008  * is concerned).
2009  *
2010  * This contract is only required for intermediate, library-like contracts.
2011  */
2012 abstract contract Context {
2013     function _msgSender() internal view virtual returns (address) {
2014         return msg.sender;
2015     }
2016 
2017     function _msgData() internal view virtual returns (bytes calldata) {
2018         return msg.data;
2019     }
2020 }
2021 
2022 // File: @openzeppelin/contracts/access/Ownable.sol
2023 
2024 
2025 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2026 
2027 pragma solidity ^0.8.0;
2028 
2029 
2030 /**
2031  * @dev Contract module which provides a basic access control mechanism, where
2032  * there is an account (an owner) that can be granted exclusive access to
2033  * specific functions.
2034  *
2035  * By default, the owner account will be the one that deploys the contract. This
2036  * can later be changed with {transferOwnership}.
2037  *
2038  * This module is used through inheritance. It will make available the modifier
2039  * `onlyOwner`, which can be applied to your functions to restrict their use to
2040  * the owner.
2041  */
2042 abstract contract Ownable is Context {
2043     address private _owner;
2044 
2045     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2046 
2047     /**
2048      * @dev Initializes the contract setting the deployer as the initial owner.
2049      */
2050     constructor() {
2051         _transferOwnership(_msgSender());
2052     }
2053 
2054     /**
2055      * @dev Throws if called by any account other than the owner.
2056      */
2057     modifier onlyOwner() {
2058         _checkOwner();
2059         _;
2060     }
2061 
2062     /**
2063      * @dev Returns the address of the current owner.
2064      */
2065     function owner() public view virtual returns (address) {
2066         return _owner;
2067     }
2068 
2069     /**
2070      * @dev Throws if the sender is not the owner.
2071      */
2072     function _checkOwner() internal view virtual {
2073         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2074     }
2075 
2076     /**
2077      * @dev Leaves the contract without owner. It will not be possible to call
2078      * `onlyOwner` functions anymore. Can only be called by the current owner.
2079      *
2080      * NOTE: Renouncing ownership will leave the contract without an owner,
2081      * thereby removing any functionality that is only available to the owner.
2082      */
2083     function renounceOwnership() public virtual onlyOwner {
2084         _transferOwnership(address(0));
2085     }
2086 
2087     /**
2088      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2089      * Can only be called by the current owner.
2090      */
2091     function transferOwnership(address newOwner) public virtual onlyOwner {
2092         require(newOwner != address(0), "Ownable: new owner is the zero address");
2093         _transferOwnership(newOwner);
2094     }
2095 
2096     /**
2097      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2098      * Internal function without access restriction.
2099      */
2100     function _transferOwnership(address newOwner) internal virtual {
2101         address oldOwner = _owner;
2102         _owner = newOwner;
2103         emit OwnershipTransferred(oldOwner, newOwner);
2104     }
2105 }
2106 
2107 // File: contracts/HRKI.sol
2108 
2109 //SPDX-License-Identifier: MIT
2110 
2111 pragma solidity ^0.8.7;
2112 
2113 
2114 
2115 
2116 
2117 
2118 
2119 
2120 contract Harakai is ERC721A, Ownable {
2121     using SafeMath for uint256;
2122 
2123     error YouCannotClaimTwice();
2124     error NoContracts();
2125     error InsufficentFundsForMint();
2126     error MintWouldExceedAllowedForIndvidualInWhitelist();
2127     error InvalidAmountToBeMinted();
2128     error NotPrelisted();
2129     error MintWouldExceedMaxSupply();
2130     error PublicSaleInactive();
2131     error PreSaleInactive();
2132 
2133     string private _baseTokenURI =
2134         "ipfs://QmTRbCM1iG7sDFUaH7vHect8vb9ycfrXtX87NmYzCaLVm3/";
2135    
2136     uint256 public constant maxSupply = 777;
2137 
2138     bool private publicSale;
2139     bool private preSale;
2140 
2141     bytes32 private presaleMerkleRoot;
2142 
2143     constructor() ERC721A("Harakai!", "HARAKAI!") {
2144         _mint(msg.sender,50);
2145         _mint(0x571C18e700cfed4FA1BE6e179770e643987475E0,25);
2146         _mint(0x1F6EfED745836A03975aa5924B3C5bDa21262fc4,20);
2147         _mint(0x444481136f7f3A8a6940ff256544fe105Cd284E9,1);
2148         _mint(0x62F5E7837a7b4eA4A4174e78FE78f5fC029B3AeB,1);
2149         _mint(0x211dbD6D9c448F7727B4aDa89d0b936e6741A9B1,2);
2150         _mint(0xFaa4f13867665e54dE10bBd6f0B338fBc9cD8c95,1);
2151         _mint(0xe9fE2AA3e59E759876A1986F91f37de3b3Be8ac9,1);
2152         _mint(0xCAaCF9B302287837993Eb5DB055d4FF9c214fcd9,1);
2153         _mint(0x543EA3B6ac7b23101354fac7DB2fCc2360881c7B,1);
2154         _mint(0x1F7a5288C948d391A7Fc5F37fF5F0128530a3F4f,1);
2155         _mint(0xdB29dA6c180D5396514725FE392defFA5B77A3cA,1);
2156         _mint(0x01503DC708ce3C55017194847A07aCb679D49f47,1);
2157         _mint(0xee43B92b789a59A8855C849A84272f1933D28439,1);
2158         _mint(0x557a5bf27885cB528f57e287D9BBc38f9dCD6430,1);
2159         _mint(0x37c47fA92c1A7a65D56D6Efa5B1799cDB7100e2e,1);
2160         _mint(0xd0017A0044EE74D5b1D2feffBcAEFF090A9Aa6Ca,1);
2161         _mint(0xaEBB58C8a0dA9866Ec673397DB66c57aF880CFa2,1);
2162         _mint(0x55c3121077D9F33b9Ed04bc6723f2A210f8B472C,1);
2163         _mint(0x246774d486B946Fb8ecB123866B5e46699aBad64,1);
2164         _mint(0x4A822F418842bD4136807fAdB3249eEc4A6c827e,1);
2165         }
2166 
2167     modifier callerIsUser() {
2168         if (msg.sender != tx.origin) revert NoContracts();
2169         _;
2170     }
2171 
2172     function viewPerWalletLimit() external pure returns (uint8) {
2173         return 1;
2174     }
2175 
2176     function mint() external callerIsUser {
2177         uint256 ts = totalSupply();
2178         if (!publicSale) revert PublicSaleInactive();
2179         if (ts + 1 > maxSupply) revert MintWouldExceedMaxSupply();
2180         if (_numberMinted(msg.sender) + 1 > 1)
2181             revert InvalidAmountToBeMinted();
2182 
2183         _mint(msg.sender, 1);
2184     }
2185 
2186     function presaleMint(bytes32[] calldata _studentProof)
2187         external
2188         callerIsUser
2189     {
2190         uint256 ts = totalSupply();
2191         if (!preSale) revert PreSaleInactive();
2192         if (ts + 1 > maxSupply)
2193             revert MintWouldExceedMaxSupply();
2194         if (
2195             !MerkleProof.verify(
2196                 _studentProof,
2197                 presaleMerkleRoot,
2198                 keccak256(abi.encodePacked(msg.sender))
2199             )
2200         ) revert NotPrelisted();
2201         if (_numberMinted(msg.sender) + 1 > 1)
2202             revert MintWouldExceedAllowedForIndvidualInWhitelist();
2203 
2204         _mint(msg.sender, 1);
2205     }
2206 
2207     function setPresaleMerkleRoot(bytes32 _presaleMerkleRoot)
2208         external
2209         onlyOwner
2210     {
2211         presaleMerkleRoot = _presaleMerkleRoot;
2212     }
2213 
2214     function isValid(address _user, bytes32[] calldata _studentProof)
2215         external
2216         view
2217         returns (bool)
2218     {
2219         return
2220             MerkleProof.verify(
2221                 _studentProof,
2222                 presaleMerkleRoot,
2223                 keccak256(abi.encodePacked(_user))
2224             );
2225 
2226     }
2227 
2228      function _baseURI() internal view virtual override returns (string memory) {
2229         return _baseTokenURI;
2230     }
2231 
2232     function setBaseURI(string calldata baseURI) external onlyOwner {
2233         _baseTokenURI = baseURI;
2234     }
2235     
2236     function isPublicSaleActive() external view returns (bool) {
2237         return publicSale;
2238     }
2239 
2240     function isPreSaleActive() external view returns (bool) {
2241         return preSale;
2242     }
2243 
2244     function togglePreSaleActive() external onlyOwner {
2245         preSale = !preSale;
2246     }
2247 
2248     function togglePublicSaleActive() external onlyOwner {
2249         publicSale = !publicSale;
2250     }
2251 }