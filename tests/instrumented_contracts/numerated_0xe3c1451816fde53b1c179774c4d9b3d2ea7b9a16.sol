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
593 // ERC721A Contracts v4.2.2
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
720     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
721 
722     /**
723      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
724      */
725     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
726 
727     /**
728      * @dev Emitted when `owner` enables or disables
729      * (`approved`) `operator` to manage all of its assets.
730      */
731     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
732 
733     /**
734      * @dev Returns the number of tokens in `owner`'s account.
735      */
736     function balanceOf(address owner) external view returns (uint256 balance);
737 
738     /**
739      * @dev Returns the owner of the `tokenId` token.
740      *
741      * Requirements:
742      *
743      * - `tokenId` must exist.
744      */
745     function ownerOf(uint256 tokenId) external view returns (address owner);
746 
747     /**
748      * @dev Safely transfers `tokenId` token from `from` to `to`,
749      * checking first that contract recipients are aware of the ERC721 protocol
750      * to prevent tokens from being forever locked.
751      *
752      * Requirements:
753      *
754      * - `from` cannot be the zero address.
755      * - `to` cannot be the zero address.
756      * - `tokenId` token must exist and be owned by `from`.
757      * - If the caller is not `from`, it must be have been allowed to move
758      * this token by either {approve} or {setApprovalForAll}.
759      * - If `to` refers to a smart contract, it must implement
760      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
761      *
762      * Emits a {Transfer} event.
763      */
764     function safeTransferFrom(
765         address from,
766         address to,
767         uint256 tokenId,
768         bytes calldata data
769     ) external;
770 
771     /**
772      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
773      */
774     function safeTransferFrom(
775         address from,
776         address to,
777         uint256 tokenId
778     ) external;
779 
780     /**
781      * @dev Transfers `tokenId` from `from` to `to`.
782      *
783      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
784      * whenever possible.
785      *
786      * Requirements:
787      *
788      * - `from` cannot be the zero address.
789      * - `to` cannot be the zero address.
790      * - `tokenId` token must be owned by `from`.
791      * - If the caller is not `from`, it must be approved to move this token
792      * by either {approve} or {setApprovalForAll}.
793      *
794      * Emits a {Transfer} event.
795      */
796     function transferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) external;
801 
802     /**
803      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
804      * The approval is cleared when the token is transferred.
805      *
806      * Only a single account can be approved at a time, so approving the
807      * zero address clears previous approvals.
808      *
809      * Requirements:
810      *
811      * - The caller must own the token or be an approved operator.
812      * - `tokenId` must exist.
813      *
814      * Emits an {Approval} event.
815      */
816     function approve(address to, uint256 tokenId) external;
817 
818     /**
819      * @dev Approve or remove `operator` as an operator for the caller.
820      * Operators can call {transferFrom} or {safeTransferFrom}
821      * for any token owned by the caller.
822      *
823      * Requirements:
824      *
825      * - The `operator` cannot be the caller.
826      *
827      * Emits an {ApprovalForAll} event.
828      */
829     function setApprovalForAll(address operator, bool _approved) external;
830 
831     /**
832      * @dev Returns the account approved for `tokenId` token.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must exist.
837      */
838     function getApproved(uint256 tokenId) external view returns (address operator);
839 
840     /**
841      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
842      *
843      * See {setApprovalForAll}.
844      */
845     function isApprovedForAll(address owner, address operator) external view returns (bool);
846 
847     // =============================================================
848     //                        IERC721Metadata
849     // =============================================================
850 
851     /**
852      * @dev Returns the token collection name.
853      */
854     function name() external view returns (string memory);
855 
856     /**
857      * @dev Returns the token collection symbol.
858      */
859     function symbol() external view returns (string memory);
860 
861     /**
862      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
863      */
864     function tokenURI(uint256 tokenId) external view returns (string memory);
865 
866     // =============================================================
867     //                           IERC2309
868     // =============================================================
869 
870     /**
871      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
872      * (inclusive) is transferred from `from` to `to`, as defined in the
873      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
874      *
875      * See {_mintERC2309} for more details.
876      */
877     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
878 }
879 // File: contracts/ERC721A.sol
880 
881 
882 // ERC721A Contracts v4.2.2
883 // Creator: Chiru Labs
884 
885 pragma solidity ^0.8.4;
886 
887 
888 /**
889  * @dev Interface of ERC721 token receiver.
890  */
891 interface ERC721A__IERC721Receiver {
892     function onERC721Received(
893         address operator,
894         address from,
895         uint256 tokenId,
896         bytes calldata data
897     ) external returns (bytes4);
898 }
899 
900 /**
901  * @title ERC721A
902  *
903  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
904  * Non-Fungible Token Standard, including the Metadata extension.
905  * Optimized for lower gas during batch mints.
906  *
907  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
908  * starting from `_startTokenId()`.
909  *
910  * Assumptions:
911  *
912  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
913  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
914  */
915 contract ERC721A is IERC721A {
916     // Reference type for token approval.
917     struct TokenApprovalRef {
918         address value;
919     }
920 
921     // =============================================================
922     //                           CONSTANTS
923     // =============================================================
924 
925     // Mask of an entry in packed address data.
926     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
927 
928     // The bit position of `numberMinted` in packed address data.
929     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
930 
931     // The bit position of `numberBurned` in packed address data.
932     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
933 
934     // The bit position of `aux` in packed address data.
935     uint256 private constant _BITPOS_AUX = 192;
936 
937     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
938     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
939 
940     // The bit position of `startTimestamp` in packed ownership.
941     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
942 
943     // The bit mask of the `burned` bit in packed ownership.
944     uint256 private constant _BITMASK_BURNED = 1 << 224;
945 
946     // The bit position of the `nextInitialized` bit in packed ownership.
947     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
948 
949     // The bit mask of the `nextInitialized` bit in packed ownership.
950     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
951 
952     // The bit position of `extraData` in packed ownership.
953     uint256 private constant _BITPOS_EXTRA_DATA = 232;
954 
955     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
956     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
957 
958     // The mask of the lower 160 bits for addresses.
959     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
960 
961     // The maximum `quantity` that can be minted with {_mintERC2309}.
962     // This limit is to prevent overflows on the address data entries.
963     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
964     // is required to cause an overflow, which is unrealistic.
965     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
966 
967     // The `Transfer` event signature is given by:
968     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
969     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
970         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
971 
972     // =============================================================
973     //                            STORAGE
974     // =============================================================
975 
976     // The next token ID to be minted.
977     uint256 private _currentIndex;
978 
979     // The number of tokens burned.
980     uint256 private _burnCounter;
981 
982     // Token name
983     string private _name;
984 
985     // Token symbol
986     string private _symbol;
987 
988     // Mapping from token ID to ownership details
989     // An empty struct value does not necessarily mean the token is unowned.
990     // See {_packedOwnershipOf} implementation for details.
991     //
992     // Bits Layout:
993     // - [0..159]   `addr`
994     // - [160..223] `startTimestamp`
995     // - [224]      `burned`
996     // - [225]      `nextInitialized`
997     // - [232..255] `extraData`
998     mapping(uint256 => uint256) private _packedOwnerships;
999 
1000     // Mapping owner address to address data.
1001     //
1002     // Bits Layout:
1003     // - [0..63]    `balance`
1004     // - [64..127]  `numberMinted`
1005     // - [128..191] `numberBurned`
1006     // - [192..255] `aux`
1007     mapping(address => uint256) private _packedAddressData;
1008 
1009     // Mapping from token ID to approved address.
1010     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1011 
1012     // Mapping from owner to operator approvals
1013     mapping(address => mapping(address => bool)) private _operatorApprovals;
1014 
1015     // =============================================================
1016     //                          CONSTRUCTOR
1017     // =============================================================
1018 
1019     constructor(string memory name_, string memory symbol_) {
1020         _name = name_;
1021         _symbol = symbol_;
1022         _currentIndex = _startTokenId();
1023     }
1024 
1025     // =============================================================
1026     //                   TOKEN COUNTING OPERATIONS
1027     // =============================================================
1028 
1029     /**
1030      * @dev Returns the starting token ID.
1031      * To change the starting token ID, please override this function.
1032      */
1033     function _startTokenId() internal view virtual returns (uint256) {
1034         return 0;
1035     }
1036 
1037     /**
1038      * @dev Returns the next token ID to be minted.
1039      */
1040     function _nextTokenId() internal view virtual returns (uint256) {
1041         return _currentIndex;
1042     }
1043 
1044     /**
1045      * @dev Returns the total number of tokens in existence.
1046      * Burned tokens will reduce the count.
1047      * To get the total number of tokens minted, please see {_totalMinted}.
1048      */
1049     function totalSupply() public view virtual override returns (uint256) {
1050         // Counter underflow is impossible as _burnCounter cannot be incremented
1051         // more than `_currentIndex - _startTokenId()` times.
1052         unchecked {
1053             return _currentIndex - _burnCounter - _startTokenId();
1054         }
1055     }
1056 
1057     /**
1058      * @dev Returns the total amount of tokens minted in the contract.
1059      */
1060     function _totalMinted() internal view virtual returns (uint256) {
1061         // Counter underflow is impossible as `_currentIndex` does not decrement,
1062         // and it is initialized to `_startTokenId()`.
1063         unchecked {
1064             return _currentIndex - _startTokenId();
1065         }
1066     }
1067 
1068     /**
1069      * @dev Returns the total number of tokens burned.
1070      */
1071     function _totalBurned() internal view virtual returns (uint256) {
1072         return _burnCounter;
1073     }
1074 
1075     // =============================================================
1076     //                    ADDRESS DATA OPERATIONS
1077     // =============================================================
1078 
1079     /**
1080      * @dev Returns the number of tokens in `owner`'s account.
1081      */
1082     function balanceOf(address owner) public view virtual override returns (uint256) {
1083         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1084         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1085     }
1086 
1087     /**
1088      * Returns the number of tokens minted by `owner`.
1089      */
1090     function _numberMinted(address owner) internal view returns (uint256) {
1091         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1092     }
1093 
1094     /**
1095      * Returns the number of tokens burned by or on behalf of `owner`.
1096      */
1097     function _numberBurned(address owner) internal view returns (uint256) {
1098         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1099     }
1100 
1101     /**
1102      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1103      */
1104     function _getAux(address owner) internal view returns (uint64) {
1105         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1106     }
1107 
1108     /**
1109      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1110      * If there are multiple variables, please pack them into a uint64.
1111      */
1112     function _setAux(address owner, uint64 aux) internal virtual {
1113         uint256 packed = _packedAddressData[owner];
1114         uint256 auxCasted;
1115         // Cast `aux` with assembly to avoid redundant masking.
1116         assembly {
1117             auxCasted := aux
1118         }
1119         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1120         _packedAddressData[owner] = packed;
1121     }
1122 
1123     // =============================================================
1124     //                            IERC165
1125     // =============================================================
1126 
1127     /**
1128      * @dev Returns true if this contract implements the interface defined by
1129      * `interfaceId`. See the corresponding
1130      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1131      * to learn more about how these ids are created.
1132      *
1133      * This function call must use less than 30000 gas.
1134      */
1135     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1136         // The interface IDs are constants representing the first 4 bytes
1137         // of the XOR of all function selectors in the interface.
1138         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1139         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1140         return
1141             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1142             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1143             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1144     }
1145 
1146     // =============================================================
1147     //                        IERC721Metadata
1148     // =============================================================
1149 
1150     /**
1151      * @dev Returns the token collection name.
1152      */
1153     function name() public view virtual override returns (string memory) {
1154         return _name;
1155     }
1156 
1157     /**
1158      * @dev Returns the token collection symbol.
1159      */
1160     function symbol() public view virtual override returns (string memory) {
1161         return _symbol;
1162     }
1163 
1164     /**
1165      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1166      */
1167     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1168         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1169 
1170         string memory baseURI = _baseURI();
1171         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1172     }
1173 
1174     /**
1175      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1176      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1177      * by default, it can be overridden in child contracts.
1178      */
1179     function _baseURI() internal view virtual returns (string memory) {
1180         return '';
1181     }
1182 
1183     // =============================================================
1184     //                     OWNERSHIPS OPERATIONS
1185     // =============================================================
1186 
1187     /**
1188      * @dev Returns the owner of the `tokenId` token.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      */
1194     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1195         return address(uint160(_packedOwnershipOf(tokenId)));
1196     }
1197 
1198     /**
1199      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1200      * It gradually moves to O(1) as tokens get transferred around over time.
1201      */
1202     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1203         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1204     }
1205 
1206     /**
1207      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1208      */
1209     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1210         return _unpackedOwnership(_packedOwnerships[index]);
1211     }
1212 
1213     /**
1214      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1215      */
1216     function _initializeOwnershipAt(uint256 index) internal virtual {
1217         if (_packedOwnerships[index] == 0) {
1218             _packedOwnerships[index] = _packedOwnershipOf(index);
1219         }
1220     }
1221 
1222     /**
1223      * Returns the packed ownership data of `tokenId`.
1224      */
1225     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1226         uint256 curr = tokenId;
1227 
1228         unchecked {
1229             if (_startTokenId() <= curr)
1230                 if (curr < _currentIndex) {
1231                     uint256 packed = _packedOwnerships[curr];
1232                     // If not burned.
1233                     if (packed & _BITMASK_BURNED == 0) {
1234                         // Invariant:
1235                         // There will always be an initialized ownership slot
1236                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1237                         // before an unintialized ownership slot
1238                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1239                         // Hence, `curr` will not underflow.
1240                         //
1241                         // We can directly compare the packed value.
1242                         // If the address is zero, packed will be zero.
1243                         while (packed == 0) {
1244                             packed = _packedOwnerships[--curr];
1245                         }
1246                         return packed;
1247                     }
1248                 }
1249         }
1250         revert OwnerQueryForNonexistentToken();
1251     }
1252 
1253     /**
1254      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1255      */
1256     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1257         ownership.addr = address(uint160(packed));
1258         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1259         ownership.burned = packed & _BITMASK_BURNED != 0;
1260         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1261     }
1262 
1263     /**
1264      * @dev Packs ownership data into a single uint256.
1265      */
1266     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1267         assembly {
1268             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1269             owner := and(owner, _BITMASK_ADDRESS)
1270             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1271             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1272         }
1273     }
1274 
1275     /**
1276      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1277      */
1278     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1279         // For branchless setting of the `nextInitialized` flag.
1280         assembly {
1281             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1282             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1283         }
1284     }
1285 
1286     // =============================================================
1287     //                      APPROVAL OPERATIONS
1288     // =============================================================
1289 
1290     /**
1291      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1292      * The approval is cleared when the token is transferred.
1293      *
1294      * Only a single account can be approved at a time, so approving the
1295      * zero address clears previous approvals.
1296      *
1297      * Requirements:
1298      *
1299      * - The caller must own the token or be an approved operator.
1300      * - `tokenId` must exist.
1301      *
1302      * Emits an {Approval} event.
1303      */
1304     function approve(address to, uint256 tokenId) public virtual override {
1305         address owner = ownerOf(tokenId);
1306 
1307         if (_msgSenderERC721A() != owner)
1308             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1309                 revert ApprovalCallerNotOwnerNorApproved();
1310             }
1311 
1312         _tokenApprovals[tokenId].value = to;
1313         emit Approval(owner, to, tokenId);
1314     }
1315 
1316     /**
1317      * @dev Returns the account approved for `tokenId` token.
1318      *
1319      * Requirements:
1320      *
1321      * - `tokenId` must exist.
1322      */
1323     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1324         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1325 
1326         return _tokenApprovals[tokenId].value;
1327     }
1328 
1329     /**
1330      * @dev Approve or remove `operator` as an operator for the caller.
1331      * Operators can call {transferFrom} or {safeTransferFrom}
1332      * for any token owned by the caller.
1333      *
1334      * Requirements:
1335      *
1336      * - The `operator` cannot be the caller.
1337      *
1338      * Emits an {ApprovalForAll} event.
1339      */
1340     function setApprovalForAll(address operator, bool approved) public virtual override {
1341         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1342 
1343         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1344         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1345     }
1346 
1347     /**
1348      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1349      *
1350      * See {setApprovalForAll}.
1351      */
1352     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1353         return _operatorApprovals[owner][operator];
1354     }
1355 
1356     /**
1357      * @dev Returns whether `tokenId` exists.
1358      *
1359      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1360      *
1361      * Tokens start existing when they are minted. See {_mint}.
1362      */
1363     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1364         return
1365             _startTokenId() <= tokenId &&
1366             tokenId < _currentIndex && // If within bounds,
1367             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1368     }
1369 
1370     /**
1371      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1372      */
1373     function _isSenderApprovedOrOwner(
1374         address approvedAddress,
1375         address owner,
1376         address msgSender
1377     ) private pure returns (bool result) {
1378         assembly {
1379             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1380             owner := and(owner, _BITMASK_ADDRESS)
1381             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1382             msgSender := and(msgSender, _BITMASK_ADDRESS)
1383             // `msgSender == owner || msgSender == approvedAddress`.
1384             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1385         }
1386     }
1387 
1388     /**
1389      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1390      */
1391     function _getApprovedSlotAndAddress(uint256 tokenId)
1392         private
1393         view
1394         returns (uint256 approvedAddressSlot, address approvedAddress)
1395     {
1396         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1397         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1398         assembly {
1399             approvedAddressSlot := tokenApproval.slot
1400             approvedAddress := sload(approvedAddressSlot)
1401         }
1402     }
1403 
1404     // =============================================================
1405     //                      TRANSFER OPERATIONS
1406     // =============================================================
1407 
1408     /**
1409      * @dev Transfers `tokenId` from `from` to `to`.
1410      *
1411      * Requirements:
1412      *
1413      * - `from` cannot be the zero address.
1414      * - `to` cannot be the zero address.
1415      * - `tokenId` token must be owned by `from`.
1416      * - If the caller is not `from`, it must be approved to move this token
1417      * by either {approve} or {setApprovalForAll}.
1418      *
1419      * Emits a {Transfer} event.
1420      */
1421     function transferFrom(
1422         address from,
1423         address to,
1424         uint256 tokenId
1425     ) public virtual override {
1426         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1427 
1428         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1429 
1430         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1431 
1432         // The nested ifs save around 20+ gas over a compound boolean condition.
1433         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1434             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1435 
1436         if (to == address(0)) revert TransferToZeroAddress();
1437 
1438         _beforeTokenTransfers(from, to, tokenId, 1);
1439 
1440         // Clear approvals from the previous owner.
1441         assembly {
1442             if approvedAddress {
1443                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1444                 sstore(approvedAddressSlot, 0)
1445             }
1446         }
1447 
1448         // Underflow of the sender's balance is impossible because we check for
1449         // ownership above and the recipient's balance can't realistically overflow.
1450         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1451         unchecked {
1452             // We can directly increment and decrement the balances.
1453             --_packedAddressData[from]; // Updates: `balance -= 1`.
1454             ++_packedAddressData[to]; // Updates: `balance += 1`.
1455 
1456             // Updates:
1457             // - `address` to the next owner.
1458             // - `startTimestamp` to the timestamp of transfering.
1459             // - `burned` to `false`.
1460             // - `nextInitialized` to `true`.
1461             _packedOwnerships[tokenId] = _packOwnershipData(
1462                 to,
1463                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1464             );
1465 
1466             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1467             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1468                 uint256 nextTokenId = tokenId + 1;
1469                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1470                 if (_packedOwnerships[nextTokenId] == 0) {
1471                     // If the next slot is within bounds.
1472                     if (nextTokenId != _currentIndex) {
1473                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1474                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1475                     }
1476                 }
1477             }
1478         }
1479 
1480         emit Transfer(from, to, tokenId);
1481         _afterTokenTransfers(from, to, tokenId, 1);
1482     }
1483 
1484     /**
1485      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1486      */
1487     function safeTransferFrom(
1488         address from,
1489         address to,
1490         uint256 tokenId
1491     ) public virtual override {
1492         safeTransferFrom(from, to, tokenId, '');
1493     }
1494 
1495     /**
1496      * @dev Safely transfers `tokenId` token from `from` to `to`.
1497      *
1498      * Requirements:
1499      *
1500      * - `from` cannot be the zero address.
1501      * - `to` cannot be the zero address.
1502      * - `tokenId` token must exist and be owned by `from`.
1503      * - If the caller is not `from`, it must be approved to move this token
1504      * by either {approve} or {setApprovalForAll}.
1505      * - If `to` refers to a smart contract, it must implement
1506      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1507      *
1508      * Emits a {Transfer} event.
1509      */
1510     function safeTransferFrom(
1511         address from,
1512         address to,
1513         uint256 tokenId,
1514         bytes memory _data
1515     ) public virtual override {
1516         transferFrom(from, to, tokenId);
1517         if (to.code.length != 0)
1518             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1519                 revert TransferToNonERC721ReceiverImplementer();
1520             }
1521     }
1522 
1523     /**
1524      * @dev Hook that is called before a set of serially-ordered token IDs
1525      * are about to be transferred. This includes minting.
1526      * And also called before burning one token.
1527      *
1528      * `startTokenId` - the first token ID to be transferred.
1529      * `quantity` - the amount to be transferred.
1530      *
1531      * Calling conditions:
1532      *
1533      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1534      * transferred to `to`.
1535      * - When `from` is zero, `tokenId` will be minted for `to`.
1536      * - When `to` is zero, `tokenId` will be burned by `from`.
1537      * - `from` and `to` are never both zero.
1538      */
1539     function _beforeTokenTransfers(
1540         address from,
1541         address to,
1542         uint256 startTokenId,
1543         uint256 quantity
1544     ) internal virtual {}
1545 
1546     /**
1547      * @dev Hook that is called after a set of serially-ordered token IDs
1548      * have been transferred. This includes minting.
1549      * And also called after one token has been burned.
1550      *
1551      * `startTokenId` - the first token ID to be transferred.
1552      * `quantity` - the amount to be transferred.
1553      *
1554      * Calling conditions:
1555      *
1556      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1557      * transferred to `to`.
1558      * - When `from` is zero, `tokenId` has been minted for `to`.
1559      * - When `to` is zero, `tokenId` has been burned by `from`.
1560      * - `from` and `to` are never both zero.
1561      */
1562     function _afterTokenTransfers(
1563         address from,
1564         address to,
1565         uint256 startTokenId,
1566         uint256 quantity
1567     ) internal virtual {}
1568 
1569     /**
1570      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1571      *
1572      * `from` - Previous owner of the given token ID.
1573      * `to` - Target address that will receive the token.
1574      * `tokenId` - Token ID to be transferred.
1575      * `_data` - Optional data to send along with the call.
1576      *
1577      * Returns whether the call correctly returned the expected magic value.
1578      */
1579     function _checkContractOnERC721Received(
1580         address from,
1581         address to,
1582         uint256 tokenId,
1583         bytes memory _data
1584     ) private returns (bool) {
1585         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1586             bytes4 retval
1587         ) {
1588             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1589         } catch (bytes memory reason) {
1590             if (reason.length == 0) {
1591                 revert TransferToNonERC721ReceiverImplementer();
1592             } else {
1593                 assembly {
1594                     revert(add(32, reason), mload(reason))
1595                 }
1596             }
1597         }
1598     }
1599 
1600     // =============================================================
1601     //                        MINT OPERATIONS
1602     // =============================================================
1603 
1604     /**
1605      * @dev Mints `quantity` tokens and transfers them to `to`.
1606      *
1607      * Requirements:
1608      *
1609      * - `to` cannot be the zero address.
1610      * - `quantity` must be greater than 0.
1611      *
1612      * Emits a {Transfer} event for each mint.
1613      */
1614     function _mint(address to, uint256 quantity) internal virtual {
1615         uint256 startTokenId = _currentIndex;
1616         if (quantity == 0) revert MintZeroQuantity();
1617 
1618         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1619 
1620         // Overflows are incredibly unrealistic.
1621         // `balance` and `numberMinted` have a maximum limit of 2**64.
1622         // `tokenId` has a maximum limit of 2**256.
1623         unchecked {
1624             // Updates:
1625             // - `balance += quantity`.
1626             // - `numberMinted += quantity`.
1627             //
1628             // We can directly add to the `balance` and `numberMinted`.
1629             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1630 
1631             // Updates:
1632             // - `address` to the owner.
1633             // - `startTimestamp` to the timestamp of minting.
1634             // - `burned` to `false`.
1635             // - `nextInitialized` to `quantity == 1`.
1636             _packedOwnerships[startTokenId] = _packOwnershipData(
1637                 to,
1638                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1639             );
1640 
1641             uint256 toMasked;
1642             uint256 end = startTokenId + quantity;
1643 
1644             // Use assembly to loop and emit the `Transfer` event for gas savings.
1645             assembly {
1646                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1647                 toMasked := and(to, _BITMASK_ADDRESS)
1648                 // Emit the `Transfer` event.
1649                 log4(
1650                     0, // Start of data (0, since no data).
1651                     0, // End of data (0, since no data).
1652                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1653                     0, // `address(0)`.
1654                     toMasked, // `to`.
1655                     startTokenId // `tokenId`.
1656                 )
1657 
1658                 for {
1659                     let tokenId := add(startTokenId, 1)
1660                 } iszero(eq(tokenId, end)) {
1661                     tokenId := add(tokenId, 1)
1662                 } {
1663                     // Emit the `Transfer` event. Similar to above.
1664                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1665                 }
1666             }
1667             if (toMasked == 0) revert MintToZeroAddress();
1668 
1669             _currentIndex = end;
1670         }
1671         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1672     }
1673 
1674     /**
1675      * @dev Mints `quantity` tokens and transfers them to `to`.
1676      *
1677      * This function is intended for efficient minting only during contract creation.
1678      *
1679      * It emits only one {ConsecutiveTransfer} as defined in
1680      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1681      * instead of a sequence of {Transfer} event(s).
1682      *
1683      * Calling this function outside of contract creation WILL make your contract
1684      * non-compliant with the ERC721 standard.
1685      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1686      * {ConsecutiveTransfer} event is only permissible during contract creation.
1687      *
1688      * Requirements:
1689      *
1690      * - `to` cannot be the zero address.
1691      * - `quantity` must be greater than 0.
1692      *
1693      * Emits a {ConsecutiveTransfer} event.
1694      */
1695     function _mintERC2309(address to, uint256 quantity) internal virtual {
1696         uint256 startTokenId = _currentIndex;
1697         if (to == address(0)) revert MintToZeroAddress();
1698         if (quantity == 0) revert MintZeroQuantity();
1699         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1700 
1701         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1702 
1703         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1704         unchecked {
1705             // Updates:
1706             // - `balance += quantity`.
1707             // - `numberMinted += quantity`.
1708             //
1709             // We can directly add to the `balance` and `numberMinted`.
1710             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1711 
1712             // Updates:
1713             // - `address` to the owner.
1714             // - `startTimestamp` to the timestamp of minting.
1715             // - `burned` to `false`.
1716             // - `nextInitialized` to `quantity == 1`.
1717             _packedOwnerships[startTokenId] = _packOwnershipData(
1718                 to,
1719                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1720             );
1721 
1722             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1723 
1724             _currentIndex = startTokenId + quantity;
1725         }
1726         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1727     }
1728 
1729     /**
1730      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1731      *
1732      * Requirements:
1733      *
1734      * - If `to` refers to a smart contract, it must implement
1735      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1736      * - `quantity` must be greater than 0.
1737      *
1738      * See {_mint}.
1739      *
1740      * Emits a {Transfer} event for each mint.
1741      */
1742     function _safeMint(
1743         address to,
1744         uint256 quantity,
1745         bytes memory _data
1746     ) internal virtual {
1747         _mint(to, quantity);
1748 
1749         unchecked {
1750             if (to.code.length != 0) {
1751                 uint256 end = _currentIndex;
1752                 uint256 index = end - quantity;
1753                 do {
1754                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1755                         revert TransferToNonERC721ReceiverImplementer();
1756                     }
1757                 } while (index < end);
1758                 // Reentrancy protection.
1759                 if (_currentIndex != end) revert();
1760             }
1761         }
1762     }
1763 
1764     /**
1765      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1766      */
1767     function _safeMint(address to, uint256 quantity) internal virtual {
1768         _safeMint(to, quantity, '');
1769     }
1770 
1771     // =============================================================
1772     //                        BURN OPERATIONS
1773     // =============================================================
1774 
1775     /**
1776      * @dev Equivalent to `_burn(tokenId, false)`.
1777      */
1778     function _burn(uint256 tokenId) internal virtual {
1779         _burn(tokenId, false);
1780     }
1781 
1782     /**
1783      * @dev Destroys `tokenId`.
1784      * The approval is cleared when the token is burned.
1785      *
1786      * Requirements:
1787      *
1788      * - `tokenId` must exist.
1789      *
1790      * Emits a {Transfer} event.
1791      */
1792     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1793         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1794 
1795         address from = address(uint160(prevOwnershipPacked));
1796 
1797         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1798 
1799         if (approvalCheck) {
1800             // The nested ifs save around 20+ gas over a compound boolean condition.
1801             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1802                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1803         }
1804 
1805         _beforeTokenTransfers(from, address(0), tokenId, 1);
1806 
1807         // Clear approvals from the previous owner.
1808         assembly {
1809             if approvedAddress {
1810                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1811                 sstore(approvedAddressSlot, 0)
1812             }
1813         }
1814 
1815         // Underflow of the sender's balance is impossible because we check for
1816         // ownership above and the recipient's balance can't realistically overflow.
1817         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1818         unchecked {
1819             // Updates:
1820             // - `balance -= 1`.
1821             // - `numberBurned += 1`.
1822             //
1823             // We can directly decrement the balance, and increment the number burned.
1824             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1825             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1826 
1827             // Updates:
1828             // - `address` to the last owner.
1829             // - `startTimestamp` to the timestamp of burning.
1830             // - `burned` to `true`.
1831             // - `nextInitialized` to `true`.
1832             _packedOwnerships[tokenId] = _packOwnershipData(
1833                 from,
1834                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1835             );
1836 
1837             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1838             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1839                 uint256 nextTokenId = tokenId + 1;
1840                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1841                 if (_packedOwnerships[nextTokenId] == 0) {
1842                     // If the next slot is within bounds.
1843                     if (nextTokenId != _currentIndex) {
1844                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1845                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1846                     }
1847                 }
1848             }
1849         }
1850 
1851         emit Transfer(from, address(0), tokenId);
1852         _afterTokenTransfers(from, address(0), tokenId, 1);
1853 
1854         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1855         unchecked {
1856             _burnCounter++;
1857         }
1858     }
1859 
1860     // =============================================================
1861     //                     EXTRA DATA OPERATIONS
1862     // =============================================================
1863 
1864     /**
1865      * @dev Directly sets the extra data for the ownership data `index`.
1866      */
1867     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1868         uint256 packed = _packedOwnerships[index];
1869         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1870         uint256 extraDataCasted;
1871         // Cast `extraData` with assembly to avoid redundant masking.
1872         assembly {
1873             extraDataCasted := extraData
1874         }
1875         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1876         _packedOwnerships[index] = packed;
1877     }
1878 
1879     /**
1880      * @dev Called during each token transfer to set the 24bit `extraData` field.
1881      * Intended to be overridden by the cosumer contract.
1882      *
1883      * `previousExtraData` - the value of `extraData` before transfer.
1884      *
1885      * Calling conditions:
1886      *
1887      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1888      * transferred to `to`.
1889      * - When `from` is zero, `tokenId` will be minted for `to`.
1890      * - When `to` is zero, `tokenId` will be burned by `from`.
1891      * - `from` and `to` are never both zero.
1892      */
1893     function _extraData(
1894         address from,
1895         address to,
1896         uint24 previousExtraData
1897     ) internal view virtual returns (uint24) {}
1898 
1899     /**
1900      * @dev Returns the next extra data for the packed ownership data.
1901      * The returned result is shifted into position.
1902      */
1903     function _nextExtraData(
1904         address from,
1905         address to,
1906         uint256 prevOwnershipPacked
1907     ) private view returns (uint256) {
1908         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1909         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1910     }
1911 
1912     // =============================================================
1913     //                       OTHER OPERATIONS
1914     // =============================================================
1915 
1916     /**
1917      * @dev Returns the message sender (defaults to `msg.sender`).
1918      *
1919      * If you are writing GSN compatible contracts, you need to override this function.
1920      */
1921     function _msgSenderERC721A() internal view virtual returns (address) {
1922         return msg.sender;
1923     }
1924 
1925     /**
1926      * @dev Converts a uint256 to its ASCII string decimal representation.
1927      */
1928     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1929         assembly {
1930             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1931             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1932             // We will need 1 32-byte word to store the length,
1933             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1934             str := add(mload(0x40), 0x80)
1935             // Update the free memory pointer to allocate.
1936             mstore(0x40, str)
1937 
1938             // Cache the end of the memory to calculate the length later.
1939             let end := str
1940 
1941             // We write the string from rightmost digit to leftmost digit.
1942             // The following is essentially a do-while loop that also handles the zero case.
1943             // prettier-ignore
1944             for { let temp := value } 1 {} {
1945                 str := sub(str, 1)
1946                 // Write the character to the pointer.
1947                 // The ASCII index of the '0' character is 48.
1948                 mstore8(str, add(48, mod(temp, 10)))
1949                 // Keep dividing `temp` until zero.
1950                 temp := div(temp, 10)
1951                 // prettier-ignore
1952                 if iszero(temp) { break }
1953             }
1954 
1955             let length := sub(end, str)
1956             // Move the pointer 32 bytes leftwards to make room for the length.
1957             str := sub(str, 0x20)
1958             // Store the length.
1959             mstore(str, length)
1960         }
1961     }
1962 }
1963 // File: @openzeppelin/contracts/utils/Context.sol
1964 
1965 
1966 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1967 
1968 pragma solidity ^0.8.0;
1969 
1970 /**
1971  * @dev Provides information about the current execution context, including the
1972  * sender of the transaction and its data. While these are generally available
1973  * via msg.sender and msg.data, they should not be accessed in such a direct
1974  * manner, since when dealing with meta-transactions the account sending and
1975  * paying for execution may not be the actual sender (as far as an application
1976  * is concerned).
1977  *
1978  * This contract is only required for intermediate, library-like contracts.
1979  */
1980 abstract contract Context {
1981     function _msgSender() internal view virtual returns (address) {
1982         return msg.sender;
1983     }
1984 
1985     function _msgData() internal view virtual returns (bytes calldata) {
1986         return msg.data;
1987     }
1988 }
1989 
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
2075 // File: contracts/WW.sol
2076 
2077 //SPDX-License-Identifier: MIT
2078 
2079 pragma solidity ^0.8.4;
2080 
2081 
2082 contract WildWest is ERC721A, Ownable, ReentrancyGuard {
2083     using Strings for uint256;
2084     using SafeMath for uint256;
2085 
2086     error MaxSupplyExceeded();
2087     error NotAllowlisted();
2088     error MaxPerWalletExceeded();
2089     error InsufficientValue();
2090     error PreSaleNotActive();
2091     error PublicSaleNotActive();
2092     error CannotIncreaseCost();
2093     error NoContracts();
2094     error CannotIncreaseTheSupply();
2095     error MintWouldExceedAllowedForIndvidualInWhitelist();
2096     error NotPrelisted();
2097     error MintWouldExceedMaxSupply();
2098     error PreSaleInactive();
2099     error AllowListIsOver();
2100 
2101     uint256 public publicCost = 0.0069 ether;
2102     uint16 public maxSupply = 5555;
2103     uint256 private allowListLimit = 1111;
2104     uint256 private allowlistCounter = 0;
2105 
2106     mapping (address => uint8) private vipClaimed;
2107 
2108     mapping (address => uint8) private _minted;
2109 
2110 
2111     uint8 public maxMintAmount = 2;
2112 
2113     string private _baseTokenURI =
2114         "https://wildwest.mypinata.cloud/ipfs/QmZgdfmwxXQZ96jyLf5zs2G9UowhTwJoLCD36UeLzkMm3X/";
2115 
2116     bytes32 private presaleMerkleRoot;
2117 
2118     bool public presaleActive;
2119     bool public publicSaleActive;
2120 
2121     constructor() ERC721A("Wild West", "WW") {
2122         _mint(0xF4A265aE0845e903D155d3B4dB18cA6465049af2, 44);
2123     }
2124 
2125     modifier callerIsUser() {
2126         if (msg.sender != tx.origin) revert NoContracts();
2127         _;
2128     }
2129 
2130     function setPresaleMerkleRoot(bytes32 _presaleMerkleRoot)
2131         external
2132         onlyOwner
2133     {
2134         presaleMerkleRoot = _presaleMerkleRoot;
2135     }
2136 
2137     function isValid(address _user, bytes32[] calldata _studentProof)
2138         external
2139         view
2140         returns (bool)
2141     {
2142         return
2143             MerkleProof.verify(
2144                 _studentProof,
2145                 presaleMerkleRoot,
2146                 keccak256(abi.encodePacked(_user))
2147             );
2148     }
2149     
2150     function setAllowlistLimit(uint256 _allowListLimit)external onlyOwner{
2151         allowListLimit = _allowListLimit;
2152     }
2153 
2154     function reduceSupply(uint16 _newReducedSupply) external onlyOwner {
2155         if (_newReducedSupply > maxSupply) revert CannotIncreaseTheSupply();
2156         maxSupply = _newReducedSupply;
2157     }
2158 
2159     function setPublicSaleCost(uint256 _newPublicCost) external onlyOwner {
2160         if (_newPublicCost > publicCost) revert CannotIncreaseCost();
2161         publicCost = _newPublicCost;
2162     }
2163     function presaleMint(bytes32[] calldata _studentProof)
2164         external
2165         callerIsUser
2166     {
2167         uint256 ts = totalSupply();
2168         if(allowlistCounter > allowListLimit) revert AllowListIsOver();
2169         if (!presaleActive) revert PreSaleInactive();
2170         if (ts + 1 > maxSupply) revert MintWouldExceedMaxSupply();
2171         if (
2172             !MerkleProof.verify(
2173                 _studentProof,
2174                 presaleMerkleRoot,
2175                 keccak256(abi.encodePacked(msg.sender))
2176             )
2177         ) revert NotPrelisted();
2178         if (vipClaimed[msg.sender] + 1 > 1)
2179             revert MintWouldExceedAllowedForIndvidualInWhitelist();
2180 
2181         allowlistCounter += 1;
2182         vipClaimed[msg.sender] += 1;
2183         _mint(msg.sender, 1);        
2184     }
2185 
2186     function mint(uint8 _amount) external payable callerIsUser {
2187         uint256 ts = totalSupply();
2188             if (!publicSaleActive) revert PublicSaleNotActive();
2189             if (ts + _amount > maxSupply - allowListLimit) revert MaxSupplyExceeded();
2190             if (_minted[msg.sender] + _amount > maxMintAmount)
2191                 revert MaxPerWalletExceeded();
2192             if (msg.value != publicCost * _amount) revert InsufficientValue();
2193 
2194             _minted[msg.sender] += _amount; 
2195 
2196             _mint(msg.sender, _amount);
2197         }
2198     
2199 
2200     function setMaxMintAmount(uint8 _maxMintAmount) external onlyOwner {
2201         maxMintAmount = _maxMintAmount;
2202     }
2203 
2204     function _baseURI() internal view virtual override returns (string memory) {
2205         return _baseTokenURI;
2206     }
2207 
2208     function setBaseURI(string calldata baseURI) external onlyOwner {
2209         _baseTokenURI = baseURI;
2210     }
2211 
2212     function togglePublicSale() external onlyOwner {
2213         publicSaleActive = !publicSaleActive;
2214     }
2215 
2216     function togglePresale() external onlyOwner {
2217         presaleActive = !presaleActive;
2218     }
2219 
2220     function withdraw() external onlyOwner nonReentrant {
2221         uint256 balance = address(this).balance;
2222         uint256 payoutDev = balance.mul(7).div(100);
2223         payable(0x3B09E02D37968f53E1de6217aB2317df6AC45824).transfer(payoutDev);
2224         balance = address(this).balance;
2225         payable(msg.sender).transfer(balance);
2226     }
2227 }