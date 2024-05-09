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
79 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 // CAUTION
87 // This version of SafeMath should only be used with Solidity 0.8 or later,
88 // because it relies on the compiler's built in overflow checks.
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations.
92  *
93  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
94  * now has built in overflow checking.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, with an overflow flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         unchecked {
104             uint256 c = a + b;
105             if (c < a) return (false, 0);
106             return (true, c);
107         }
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
112      *
113      * _Available since v3.4._
114      */
115     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
116         unchecked {
117             if (b > a) return (false, 0);
118             return (true, a - b);
119         }
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
124      *
125      * _Available since v3.4._
126      */
127     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
128         unchecked {
129             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130             // benefit is lost if 'b' is also tested.
131             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
132             if (a == 0) return (true, 0);
133             uint256 c = a * b;
134             if (c / a != b) return (false, 0);
135             return (true, c);
136         }
137     }
138 
139     /**
140      * @dev Returns the division of two unsigned integers, with a division by zero flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         unchecked {
146             if (b == 0) return (false, 0);
147             return (true, a / b);
148         }
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
153      *
154      * _Available since v3.4._
155      */
156     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
157         unchecked {
158             if (b == 0) return (false, 0);
159             return (true, a % b);
160         }
161     }
162 
163     /**
164      * @dev Returns the addition of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `+` operator.
168      *
169      * Requirements:
170      *
171      * - Addition cannot overflow.
172      */
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a + b;
175     }
176 
177     /**
178      * @dev Returns the subtraction of two unsigned integers, reverting on
179      * overflow (when the result is negative).
180      *
181      * Counterpart to Solidity's `-` operator.
182      *
183      * Requirements:
184      *
185      * - Subtraction cannot overflow.
186      */
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         return a - b;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         return a * b;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers, reverting on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator.
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return a / b;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * reverting when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a % b;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237      * overflow (when the result is negative).
238      *
239      * CAUTION: This function is deprecated because it requires allocating memory for the error
240      * message unnecessarily. For custom revert reasons use {trySub}.
241      *
242      * Counterpart to Solidity's `-` operator.
243      *
244      * Requirements:
245      *
246      * - Subtraction cannot overflow.
247      */
248     function sub(
249         uint256 a,
250         uint256 b,
251         string memory errorMessage
252     ) internal pure returns (uint256) {
253         unchecked {
254             require(b <= a, errorMessage);
255             return a - b;
256         }
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         unchecked {
277             require(b > 0, errorMessage);
278             return a / b;
279         }
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * reverting with custom message when dividing by zero.
285      *
286      * CAUTION: This function is deprecated because it requires allocating memory for the error
287      * message unnecessarily. For custom revert reasons use {tryMod}.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function mod(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         unchecked {
303             require(b > 0, errorMessage);
304             return a % b;
305         }
306     }
307 }
308 
309 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
310 
311 
312 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @dev These functions deal with verification of Merkle Tree proofs.
318  *
319  * The proofs can be generated using the JavaScript library
320  * https://github.com/miguelmota/merkletreejs[merkletreejs].
321  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
322  *
323  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
324  *
325  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
326  * hashing, or use a hash function other than keccak256 for hashing leaves.
327  * This is because the concatenation of a sorted pair of internal nodes in
328  * the merkle tree could be reinterpreted as a leaf value.
329  */
330 library MerkleProof {
331     /**
332      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
333      * defined by `root`. For this, a `proof` must be provided, containing
334      * sibling hashes on the branch from the leaf to the root of the tree. Each
335      * pair of leaves and each pair of pre-images are assumed to be sorted.
336      */
337     function verify(
338         bytes32[] memory proof,
339         bytes32 root,
340         bytes32 leaf
341     ) internal pure returns (bool) {
342         return processProof(proof, leaf) == root;
343     }
344 
345     /**
346      * @dev Calldata version of {verify}
347      *
348      * _Available since v4.7._
349      */
350     function verifyCalldata(
351         bytes32[] calldata proof,
352         bytes32 root,
353         bytes32 leaf
354     ) internal pure returns (bool) {
355         return processProofCalldata(proof, leaf) == root;
356     }
357 
358     /**
359      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
360      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
361      * hash matches the root of the tree. When processing the proof, the pairs
362      * of leafs & pre-images are assumed to be sorted.
363      *
364      * _Available since v4.4._
365      */
366     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
367         bytes32 computedHash = leaf;
368         for (uint256 i = 0; i < proof.length; i++) {
369             computedHash = _hashPair(computedHash, proof[i]);
370         }
371         return computedHash;
372     }
373 
374     /**
375      * @dev Calldata version of {processProof}
376      *
377      * _Available since v4.7._
378      */
379     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
380         bytes32 computedHash = leaf;
381         for (uint256 i = 0; i < proof.length; i++) {
382             computedHash = _hashPair(computedHash, proof[i]);
383         }
384         return computedHash;
385     }
386 
387     /**
388      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
389      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
390      *
391      * _Available since v4.7._
392      */
393     function multiProofVerify(
394         bytes32[] memory proof,
395         bool[] memory proofFlags,
396         bytes32 root,
397         bytes32[] memory leaves
398     ) internal pure returns (bool) {
399         return processMultiProof(proof, proofFlags, leaves) == root;
400     }
401 
402     /**
403      * @dev Calldata version of {multiProofVerify}
404      *
405      * _Available since v4.7._
406      */
407     function multiProofVerifyCalldata(
408         bytes32[] calldata proof,
409         bool[] calldata proofFlags,
410         bytes32 root,
411         bytes32[] memory leaves
412     ) internal pure returns (bool) {
413         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
414     }
415 
416     /**
417      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
418      * consuming from one or the other at each step according to the instructions given by
419      * `proofFlags`.
420      *
421      * _Available since v4.7._
422      */
423     function processMultiProof(
424         bytes32[] memory proof,
425         bool[] memory proofFlags,
426         bytes32[] memory leaves
427     ) internal pure returns (bytes32 merkleRoot) {
428         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
429         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
430         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
431         // the merkle tree.
432         uint256 leavesLen = leaves.length;
433         uint256 totalHashes = proofFlags.length;
434 
435         // Check proof validity.
436         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
437 
438         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
439         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
440         bytes32[] memory hashes = new bytes32[](totalHashes);
441         uint256 leafPos = 0;
442         uint256 hashPos = 0;
443         uint256 proofPos = 0;
444         // At each step, we compute the next hash using two values:
445         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
446         //   get the next hash.
447         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
448         //   `proof` array.
449         for (uint256 i = 0; i < totalHashes; i++) {
450             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
451             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
452             hashes[i] = _hashPair(a, b);
453         }
454 
455         if (totalHashes > 0) {
456             return hashes[totalHashes - 1];
457         } else if (leavesLen > 0) {
458             return leaves[0];
459         } else {
460             return proof[0];
461         }
462     }
463 
464     /**
465      * @dev Calldata version of {processMultiProof}
466      *
467      * _Available since v4.7._
468      */
469     function processMultiProofCalldata(
470         bytes32[] calldata proof,
471         bool[] calldata proofFlags,
472         bytes32[] memory leaves
473     ) internal pure returns (bytes32 merkleRoot) {
474         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
475         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
476         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
477         // the merkle tree.
478         uint256 leavesLen = leaves.length;
479         uint256 totalHashes = proofFlags.length;
480 
481         // Check proof validity.
482         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
483 
484         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
485         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
486         bytes32[] memory hashes = new bytes32[](totalHashes);
487         uint256 leafPos = 0;
488         uint256 hashPos = 0;
489         uint256 proofPos = 0;
490         // At each step, we compute the next hash using two values:
491         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
492         //   get the next hash.
493         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
494         //   `proof` array.
495         for (uint256 i = 0; i < totalHashes; i++) {
496             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
497             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
498             hashes[i] = _hashPair(a, b);
499         }
500 
501         if (totalHashes > 0) {
502             return hashes[totalHashes - 1];
503         } else if (leavesLen > 0) {
504             return leaves[0];
505         } else {
506             return proof[0];
507         }
508     }
509 
510     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
511         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
512     }
513 
514     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
515         /// @solidity memory-safe-assembly
516         assembly {
517             mstore(0x00, a)
518             mstore(0x20, b)
519             value := keccak256(0x00, 0x40)
520         }
521     }
522 }
523 
524 // File: @openzeppelin/contracts/utils/Context.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Provides information about the current execution context, including the
533  * sender of the transaction and its data. While these are generally available
534  * via msg.sender and msg.data, they should not be accessed in such a direct
535  * manner, since when dealing with meta-transactions the account sending and
536  * paying for execution may not be the actual sender (as far as an application
537  * is concerned).
538  *
539  * This contract is only required for intermediate, library-like contracts.
540  */
541 abstract contract Context {
542     function _msgSender() internal view virtual returns (address) {
543         return msg.sender;
544     }
545 
546     function _msgData() internal view virtual returns (bytes calldata) {
547         return msg.data;
548     }
549 }
550 
551 // File: @openzeppelin/contracts/access/Ownable.sol
552 
553 
554 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 
559 /**
560  * @dev Contract module which provides a basic access control mechanism, where
561  * there is an account (an owner) that can be granted exclusive access to
562  * specific functions.
563  *
564  * By default, the owner account will be the one that deploys the contract. This
565  * can later be changed with {transferOwnership}.
566  *
567  * This module is used through inheritance. It will make available the modifier
568  * `onlyOwner`, which can be applied to your functions to restrict their use to
569  * the owner.
570  */
571 abstract contract Ownable is Context {
572     address private _owner;
573 
574     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
575 
576     /**
577      * @dev Initializes the contract setting the deployer as the initial owner.
578      */
579     constructor() {
580         _transferOwnership(_msgSender());
581     }
582 
583     /**
584      * @dev Throws if called by any account other than the owner.
585      */
586     modifier onlyOwner() {
587         _checkOwner();
588         _;
589     }
590 
591     /**
592      * @dev Returns the address of the current owner.
593      */
594     function owner() public view virtual returns (address) {
595         return _owner;
596     }
597 
598     /**
599      * @dev Throws if the sender is not the owner.
600      */
601     function _checkOwner() internal view virtual {
602         require(owner() == _msgSender(), "Ownable: caller is not the owner");
603     }
604 
605     /**
606      * @dev Leaves the contract without owner. It will not be possible to call
607      * `onlyOwner` functions anymore. Can only be called by the current owner.
608      *
609      * NOTE: Renouncing ownership will leave the contract without an owner,
610      * thereby removing any functionality that is only available to the owner.
611      */
612     function renounceOwnership() public virtual onlyOwner {
613         _transferOwnership(address(0));
614     }
615 
616     /**
617      * @dev Transfers ownership of the contract to a new account (`newOwner`).
618      * Can only be called by the current owner.
619      */
620     function transferOwnership(address newOwner) public virtual onlyOwner {
621         require(newOwner != address(0), "Ownable: new owner is the zero address");
622         _transferOwnership(newOwner);
623     }
624 
625     /**
626      * @dev Transfers ownership of the contract to a new account (`newOwner`).
627      * Internal function without access restriction.
628      */
629     function _transferOwnership(address newOwner) internal virtual {
630         address oldOwner = _owner;
631         _owner = newOwner;
632         emit OwnershipTransferred(oldOwner, newOwner);
633     }
634 }
635 
636 // File: erc721a/contracts/IERC721A.sol
637 
638 
639 // ERC721A Contracts v4.2.3
640 // Creator: Chiru Labs
641 
642 pragma solidity ^0.8.4;
643 
644 /**
645  * @dev Interface of ERC721A.
646  */
647 interface IERC721A {
648     /**
649      * The caller must own the token or be an approved operator.
650      */
651     error ApprovalCallerNotOwnerNorApproved();
652 
653     /**
654      * The token does not exist.
655      */
656     error ApprovalQueryForNonexistentToken();
657 
658     /**
659      * Cannot query the balance for the zero address.
660      */
661     error BalanceQueryForZeroAddress();
662 
663     /**
664      * Cannot mint to the zero address.
665      */
666     error MintToZeroAddress();
667 
668     /**
669      * The quantity of tokens minted must be more than zero.
670      */
671     error MintZeroQuantity();
672 
673     /**
674      * The token does not exist.
675      */
676     error OwnerQueryForNonexistentToken();
677 
678     /**
679      * The caller must own the token or be an approved operator.
680      */
681     error TransferCallerNotOwnerNorApproved();
682 
683     /**
684      * The token must be owned by `from`.
685      */
686     error TransferFromIncorrectOwner();
687 
688     /**
689      * Cannot safely transfer to a contract that does not implement the
690      * ERC721Receiver interface.
691      */
692     error TransferToNonERC721ReceiverImplementer();
693 
694     /**
695      * Cannot transfer to the zero address.
696      */
697     error TransferToZeroAddress();
698 
699     /**
700      * The token does not exist.
701      */
702     error URIQueryForNonexistentToken();
703 
704     /**
705      * The `quantity` minted with ERC2309 exceeds the safety limit.
706      */
707     error MintERC2309QuantityExceedsLimit();
708 
709     /**
710      * The `extraData` cannot be set on an unintialized ownership slot.
711      */
712     error OwnershipNotInitializedForExtraData();
713 
714     // =============================================================
715     //                            STRUCTS
716     // =============================================================
717 
718     struct TokenOwnership {
719         // The address of the owner.
720         address addr;
721         // Stores the start time of ownership with minimal overhead for tokenomics.
722         uint64 startTimestamp;
723         // Whether the token has been burned.
724         bool burned;
725         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
726         uint24 extraData;
727     }
728 
729     // =============================================================
730     //                         TOKEN COUNTERS
731     // =============================================================
732 
733     /**
734      * @dev Returns the total number of tokens in existence.
735      * Burned tokens will reduce the count.
736      * To get the total number of tokens minted, please see {_totalMinted}.
737      */
738     function totalSupply() external view returns (uint256);
739 
740     // =============================================================
741     //                            IERC165
742     // =============================================================
743 
744     /**
745      * @dev Returns true if this contract implements the interface defined by
746      * `interfaceId`. See the corresponding
747      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
748      * to learn more about how these ids are created.
749      *
750      * This function call must use less than 30000 gas.
751      */
752     function supportsInterface(bytes4 interfaceId) external view returns (bool);
753 
754     // =============================================================
755     //                            IERC721
756     // =============================================================
757 
758     /**
759      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
760      */
761     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
762 
763     /**
764      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
765      */
766     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
767 
768     /**
769      * @dev Emitted when `owner` enables or disables
770      * (`approved`) `operator` to manage all of its assets.
771      */
772     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
773 
774     /**
775      * @dev Returns the number of tokens in `owner`'s account.
776      */
777     function balanceOf(address owner) external view returns (uint256 balance);
778 
779     /**
780      * @dev Returns the owner of the `tokenId` token.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must exist.
785      */
786     function ownerOf(uint256 tokenId) external view returns (address owner);
787 
788     /**
789      * @dev Safely transfers `tokenId` token from `from` to `to`,
790      * checking first that contract recipients are aware of the ERC721 protocol
791      * to prevent tokens from being forever locked.
792      *
793      * Requirements:
794      *
795      * - `from` cannot be the zero address.
796      * - `to` cannot be the zero address.
797      * - `tokenId` token must exist and be owned by `from`.
798      * - If the caller is not `from`, it must be have been allowed to move
799      * this token by either {approve} or {setApprovalForAll}.
800      * - If `to` refers to a smart contract, it must implement
801      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
802      *
803      * Emits a {Transfer} event.
804      */
805     function safeTransferFrom(
806         address from,
807         address to,
808         uint256 tokenId,
809         bytes calldata data
810     ) external payable;
811 
812     /**
813      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
814      */
815     function safeTransferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) external payable;
820 
821     /**
822      * @dev Transfers `tokenId` from `from` to `to`.
823      *
824      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
825      * whenever possible.
826      *
827      * Requirements:
828      *
829      * - `from` cannot be the zero address.
830      * - `to` cannot be the zero address.
831      * - `tokenId` token must be owned by `from`.
832      * - If the caller is not `from`, it must be approved to move this token
833      * by either {approve} or {setApprovalForAll}.
834      *
835      * Emits a {Transfer} event.
836      */
837     function transferFrom(
838         address from,
839         address to,
840         uint256 tokenId
841     ) external payable;
842 
843     /**
844      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
845      * The approval is cleared when the token is transferred.
846      *
847      * Only a single account can be approved at a time, so approving the
848      * zero address clears previous approvals.
849      *
850      * Requirements:
851      *
852      * - The caller must own the token or be an approved operator.
853      * - `tokenId` must exist.
854      *
855      * Emits an {Approval} event.
856      */
857     function approve(address to, uint256 tokenId) external payable;
858 
859     /**
860      * @dev Approve or remove `operator` as an operator for the caller.
861      * Operators can call {transferFrom} or {safeTransferFrom}
862      * for any token owned by the caller.
863      *
864      * Requirements:
865      *
866      * - The `operator` cannot be the caller.
867      *
868      * Emits an {ApprovalForAll} event.
869      */
870     function setApprovalForAll(address operator, bool _approved) external;
871 
872     /**
873      * @dev Returns the account approved for `tokenId` token.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      */
879     function getApproved(uint256 tokenId) external view returns (address operator);
880 
881     /**
882      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
883      *
884      * See {setApprovalForAll}.
885      */
886     function isApprovedForAll(address owner, address operator) external view returns (bool);
887 
888     // =============================================================
889     //                        IERC721Metadata
890     // =============================================================
891 
892     /**
893      * @dev Returns the token collection name.
894      */
895     function name() external view returns (string memory);
896 
897     /**
898      * @dev Returns the token collection symbol.
899      */
900     function symbol() external view returns (string memory);
901 
902     /**
903      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
904      */
905     function tokenURI(uint256 tokenId) external view returns (string memory);
906 
907     // =============================================================
908     //                           IERC2309
909     // =============================================================
910 
911     /**
912      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
913      * (inclusive) is transferred from `from` to `to`, as defined in the
914      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
915      *
916      * See {_mintERC2309} for more details.
917      */
918     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
919 }
920 
921 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
922 
923 
924 // ERC721A Contracts v4.2.3
925 // Creator: Chiru Labs
926 
927 pragma solidity ^0.8.4;
928 
929 
930 /**
931  * @dev Interface of ERC721AQueryable.
932  */
933 interface IERC721AQueryable is IERC721A {
934     /**
935      * Invalid query range (`start` >= `stop`).
936      */
937     error InvalidQueryRange();
938 
939     /**
940      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
941      *
942      * If the `tokenId` is out of bounds:
943      *
944      * - `addr = address(0)`
945      * - `startTimestamp = 0`
946      * - `burned = false`
947      * - `extraData = 0`
948      *
949      * If the `tokenId` is burned:
950      *
951      * - `addr = <Address of owner before token was burned>`
952      * - `startTimestamp = <Timestamp when token was burned>`
953      * - `burned = true`
954      * - `extraData = <Extra data when token was burned>`
955      *
956      * Otherwise:
957      *
958      * - `addr = <Address of owner>`
959      * - `startTimestamp = <Timestamp of start of ownership>`
960      * - `burned = false`
961      * - `extraData = <Extra data at start of ownership>`
962      */
963     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
964 
965     /**
966      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
967      * See {ERC721AQueryable-explicitOwnershipOf}
968      */
969     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
970 
971     /**
972      * @dev Returns an array of token IDs owned by `owner`,
973      * in the range [`start`, `stop`)
974      * (i.e. `start <= tokenId < stop`).
975      *
976      * This function allows for tokens to be queried if the collection
977      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
978      *
979      * Requirements:
980      *
981      * - `start < stop`
982      */
983     function tokensOfOwnerIn(
984         address owner,
985         uint256 start,
986         uint256 stop
987     ) external view returns (uint256[] memory);
988 
989     /**
990      * @dev Returns an array of token IDs owned by `owner`.
991      *
992      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
993      * It is meant to be called off-chain.
994      *
995      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
996      * multiple smaller scans if the collection is large enough to cause
997      * an out-of-gas error (10K collections should be fine).
998      */
999     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1000 }
1001 
1002 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
1003 
1004 
1005 // ERC721A Contracts v4.2.3
1006 // Creator: Chiru Labs
1007 
1008 pragma solidity ^0.8.4;
1009 
1010 
1011 /**
1012  * @dev Interface of ERC721ABurnable.
1013  */
1014 interface IERC721ABurnable is IERC721A {
1015     /**
1016      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1017      *
1018      * Requirements:
1019      *
1020      * - The caller must own `tokenId` or be an approved operator.
1021      */
1022     function burn(uint256 tokenId) external;
1023 }
1024 
1025 // File: erc721a/contracts/ERC721A.sol
1026 
1027 
1028 // ERC721A Contracts v4.2.3
1029 // Creator: Chiru Labs
1030 
1031 pragma solidity ^0.8.4;
1032 
1033 
1034 /**
1035  * @dev Interface of ERC721 token receiver.
1036  */
1037 interface ERC721A__IERC721Receiver {
1038     function onERC721Received(
1039         address operator,
1040         address from,
1041         uint256 tokenId,
1042         bytes calldata data
1043     ) external returns (bytes4);
1044 }
1045 
1046 /**
1047  * @title ERC721A
1048  *
1049  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1050  * Non-Fungible Token Standard, including the Metadata extension.
1051  * Optimized for lower gas during batch mints.
1052  *
1053  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1054  * starting from `_startTokenId()`.
1055  *
1056  * Assumptions:
1057  *
1058  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1059  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1060  */
1061 contract ERC721A is IERC721A {
1062     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1063     struct TokenApprovalRef {
1064         address value;
1065     }
1066 
1067     // =============================================================
1068     //                           CONSTANTS
1069     // =============================================================
1070 
1071     // Mask of an entry in packed address data.
1072     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1073 
1074     // The bit position of `numberMinted` in packed address data.
1075     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1076 
1077     // The bit position of `numberBurned` in packed address data.
1078     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1079 
1080     // The bit position of `aux` in packed address data.
1081     uint256 private constant _BITPOS_AUX = 192;
1082 
1083     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1084     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1085 
1086     // The bit position of `startTimestamp` in packed ownership.
1087     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1088 
1089     // The bit mask of the `burned` bit in packed ownership.
1090     uint256 private constant _BITMASK_BURNED = 1 << 224;
1091 
1092     // The bit position of the `nextInitialized` bit in packed ownership.
1093     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1094 
1095     // The bit mask of the `nextInitialized` bit in packed ownership.
1096     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1097 
1098     // The bit position of `extraData` in packed ownership.
1099     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1100 
1101     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1102     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1103 
1104     // The mask of the lower 160 bits for addresses.
1105     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1106 
1107     // The maximum `quantity` that can be minted with {_mintERC2309}.
1108     // This limit is to prevent overflows on the address data entries.
1109     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1110     // is required to cause an overflow, which is unrealistic.
1111     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1112 
1113     // The `Transfer` event signature is given by:
1114     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1115     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1116         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1117 
1118     // =============================================================
1119     //                            STORAGE
1120     // =============================================================
1121 
1122     // The next token ID to be minted.
1123     uint256 private _currentIndex;
1124 
1125     // The number of tokens burned.
1126     uint256 private _burnCounter;
1127 
1128     // Token name
1129     string private _name;
1130 
1131     // Token symbol
1132     string private _symbol;
1133 
1134     // Mapping from token ID to ownership details
1135     // An empty struct value does not necessarily mean the token is unowned.
1136     // See {_packedOwnershipOf} implementation for details.
1137     //
1138     // Bits Layout:
1139     // - [0..159]   `addr`
1140     // - [160..223] `startTimestamp`
1141     // - [224]      `burned`
1142     // - [225]      `nextInitialized`
1143     // - [232..255] `extraData`
1144     mapping(uint256 => uint256) private _packedOwnerships;
1145 
1146     // Mapping owner address to address data.
1147     //
1148     // Bits Layout:
1149     // - [0..63]    `balance`
1150     // - [64..127]  `numberMinted`
1151     // - [128..191] `numberBurned`
1152     // - [192..255] `aux`
1153     mapping(address => uint256) private _packedAddressData;
1154 
1155     // Mapping from token ID to approved address.
1156     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1157 
1158     // Mapping from owner to operator approvals
1159     mapping(address => mapping(address => bool)) private _operatorApprovals;
1160 
1161     // =============================================================
1162     //                          CONSTRUCTOR
1163     // =============================================================
1164 
1165     constructor(string memory name_, string memory symbol_) {
1166         _name = name_;
1167         _symbol = symbol_;
1168         _currentIndex = _startTokenId();
1169     }
1170 
1171     // =============================================================
1172     //                   TOKEN COUNTING OPERATIONS
1173     // =============================================================
1174 
1175     /**
1176      * @dev Returns the starting token ID.
1177      * To change the starting token ID, please override this function.
1178      */
1179     function _startTokenId() internal view virtual returns (uint256) {
1180         return 0;
1181     }
1182 
1183     /**
1184      * @dev Returns the next token ID to be minted.
1185      */
1186     function _nextTokenId() internal view virtual returns (uint256) {
1187         return _currentIndex;
1188     }
1189 
1190     /**
1191      * @dev Returns the total number of tokens in existence.
1192      * Burned tokens will reduce the count.
1193      * To get the total number of tokens minted, please see {_totalMinted}.
1194      */
1195     function totalSupply() public view virtual override returns (uint256) {
1196         // Counter underflow is impossible as _burnCounter cannot be incremented
1197         // more than `_currentIndex - _startTokenId()` times.
1198         unchecked {
1199             return _currentIndex - _burnCounter - _startTokenId();
1200         }
1201     }
1202 
1203     /**
1204      * @dev Returns the total amount of tokens minted in the contract.
1205      */
1206     function _totalMinted() internal view virtual returns (uint256) {
1207         // Counter underflow is impossible as `_currentIndex` does not decrement,
1208         // and it is initialized to `_startTokenId()`.
1209         unchecked {
1210             return _currentIndex - _startTokenId();
1211         }
1212     }
1213 
1214     /**
1215      * @dev Returns the total number of tokens burned.
1216      */
1217     function _totalBurned() internal view virtual returns (uint256) {
1218         return _burnCounter;
1219     }
1220 
1221     // =============================================================
1222     //                    ADDRESS DATA OPERATIONS
1223     // =============================================================
1224 
1225     /**
1226      * @dev Returns the number of tokens in `owner`'s account.
1227      */
1228     function balanceOf(address owner) public view virtual override returns (uint256) {
1229         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1230         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1231     }
1232 
1233     /**
1234      * Returns the number of tokens minted by `owner`.
1235      */
1236     function _numberMinted(address owner) internal view returns (uint256) {
1237         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1238     }
1239 
1240     /**
1241      * Returns the number of tokens burned by or on behalf of `owner`.
1242      */
1243     function _numberBurned(address owner) internal view returns (uint256) {
1244         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1245     }
1246 
1247     /**
1248      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1249      */
1250     function _getAux(address owner) internal view returns (uint64) {
1251         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1252     }
1253 
1254     /**
1255      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1256      * If there are multiple variables, please pack them into a uint64.
1257      */
1258     function _setAux(address owner, uint64 aux) internal virtual {
1259         uint256 packed = _packedAddressData[owner];
1260         uint256 auxCasted;
1261         // Cast `aux` with assembly to avoid redundant masking.
1262         assembly {
1263             auxCasted := aux
1264         }
1265         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1266         _packedAddressData[owner] = packed;
1267     }
1268 
1269     // =============================================================
1270     //                            IERC165
1271     // =============================================================
1272 
1273     /**
1274      * @dev Returns true if this contract implements the interface defined by
1275      * `interfaceId`. See the corresponding
1276      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1277      * to learn more about how these ids are created.
1278      *
1279      * This function call must use less than 30000 gas.
1280      */
1281     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1282         // The interface IDs are constants representing the first 4 bytes
1283         // of the XOR of all function selectors in the interface.
1284         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1285         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1286         return
1287             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1288             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1289             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1290     }
1291 
1292     // =============================================================
1293     //                        IERC721Metadata
1294     // =============================================================
1295 
1296     /**
1297      * @dev Returns the token collection name.
1298      */
1299     function name() public view virtual override returns (string memory) {
1300         return _name;
1301     }
1302 
1303     /**
1304      * @dev Returns the token collection symbol.
1305      */
1306     function symbol() public view virtual override returns (string memory) {
1307         return _symbol;
1308     }
1309 
1310     /**
1311      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1312      */
1313     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1314         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1315 
1316         string memory baseURI = _baseURI();
1317         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1318     }
1319 
1320     /**
1321      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1322      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1323      * by default, it can be overridden in child contracts.
1324      */
1325     function _baseURI() internal view virtual returns (string memory) {
1326         return '';
1327     }
1328 
1329     // =============================================================
1330     //                     OWNERSHIPS OPERATIONS
1331     // =============================================================
1332 
1333     /**
1334      * @dev Returns the owner of the `tokenId` token.
1335      *
1336      * Requirements:
1337      *
1338      * - `tokenId` must exist.
1339      */
1340     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1341         return address(uint160(_packedOwnershipOf(tokenId)));
1342     }
1343 
1344     /**
1345      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1346      * It gradually moves to O(1) as tokens get transferred around over time.
1347      */
1348     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1349         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1350     }
1351 
1352     /**
1353      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1354      */
1355     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1356         return _unpackedOwnership(_packedOwnerships[index]);
1357     }
1358 
1359     /**
1360      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1361      */
1362     function _initializeOwnershipAt(uint256 index) internal virtual {
1363         if (_packedOwnerships[index] == 0) {
1364             _packedOwnerships[index] = _packedOwnershipOf(index);
1365         }
1366     }
1367 
1368     /**
1369      * Returns the packed ownership data of `tokenId`.
1370      */
1371     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1372         uint256 curr = tokenId;
1373 
1374         unchecked {
1375             if (_startTokenId() <= curr)
1376                 if (curr < _currentIndex) {
1377                     uint256 packed = _packedOwnerships[curr];
1378                     // If not burned.
1379                     if (packed & _BITMASK_BURNED == 0) {
1380                         // Invariant:
1381                         // There will always be an initialized ownership slot
1382                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1383                         // before an unintialized ownership slot
1384                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1385                         // Hence, `curr` will not underflow.
1386                         //
1387                         // We can directly compare the packed value.
1388                         // If the address is zero, packed will be zero.
1389                         while (packed == 0) {
1390                             packed = _packedOwnerships[--curr];
1391                         }
1392                         return packed;
1393                     }
1394                 }
1395         }
1396         revert OwnerQueryForNonexistentToken();
1397     }
1398 
1399     /**
1400      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1401      */
1402     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1403         ownership.addr = address(uint160(packed));
1404         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1405         ownership.burned = packed & _BITMASK_BURNED != 0;
1406         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1407     }
1408 
1409     /**
1410      * @dev Packs ownership data into a single uint256.
1411      */
1412     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1413         assembly {
1414             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1415             owner := and(owner, _BITMASK_ADDRESS)
1416             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1417             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1418         }
1419     }
1420 
1421     /**
1422      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1423      */
1424     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1425         // For branchless setting of the `nextInitialized` flag.
1426         assembly {
1427             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1428             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1429         }
1430     }
1431 
1432     // =============================================================
1433     //                      APPROVAL OPERATIONS
1434     // =============================================================
1435 
1436     /**
1437      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1438      * The approval is cleared when the token is transferred.
1439      *
1440      * Only a single account can be approved at a time, so approving the
1441      * zero address clears previous approvals.
1442      *
1443      * Requirements:
1444      *
1445      * - The caller must own the token or be an approved operator.
1446      * - `tokenId` must exist.
1447      *
1448      * Emits an {Approval} event.
1449      */
1450     function approve(address to, uint256 tokenId) public payable virtual override {
1451         address owner = ownerOf(tokenId);
1452 
1453         if (_msgSenderERC721A() != owner)
1454             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1455                 revert ApprovalCallerNotOwnerNorApproved();
1456             }
1457 
1458         _tokenApprovals[tokenId].value = to;
1459         emit Approval(owner, to, tokenId);
1460     }
1461 
1462     /**
1463      * @dev Returns the account approved for `tokenId` token.
1464      *
1465      * Requirements:
1466      *
1467      * - `tokenId` must exist.
1468      */
1469     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1470         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1471 
1472         return _tokenApprovals[tokenId].value;
1473     }
1474 
1475     /**
1476      * @dev Approve or remove `operator` as an operator for the caller.
1477      * Operators can call {transferFrom} or {safeTransferFrom}
1478      * for any token owned by the caller.
1479      *
1480      * Requirements:
1481      *
1482      * - The `operator` cannot be the caller.
1483      *
1484      * Emits an {ApprovalForAll} event.
1485      */
1486     function setApprovalForAll(address operator, bool approved) public virtual override {
1487         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1488         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1489     }
1490 
1491     /**
1492      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1493      *
1494      * See {setApprovalForAll}.
1495      */
1496     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1497         return _operatorApprovals[owner][operator];
1498     }
1499 
1500     /**
1501      * @dev Returns whether `tokenId` exists.
1502      *
1503      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1504      *
1505      * Tokens start existing when they are minted. See {_mint}.
1506      */
1507     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1508         return
1509             _startTokenId() <= tokenId &&
1510             tokenId < _currentIndex && // If within bounds,
1511             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1512     }
1513 
1514     /**
1515      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1516      */
1517     function _isSenderApprovedOrOwner(
1518         address approvedAddress,
1519         address owner,
1520         address msgSender
1521     ) private pure returns (bool result) {
1522         assembly {
1523             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1524             owner := and(owner, _BITMASK_ADDRESS)
1525             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1526             msgSender := and(msgSender, _BITMASK_ADDRESS)
1527             // `msgSender == owner || msgSender == approvedAddress`.
1528             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1529         }
1530     }
1531 
1532     /**
1533      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1534      */
1535     function _getApprovedSlotAndAddress(uint256 tokenId)
1536         private
1537         view
1538         returns (uint256 approvedAddressSlot, address approvedAddress)
1539     {
1540         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1541         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1542         assembly {
1543             approvedAddressSlot := tokenApproval.slot
1544             approvedAddress := sload(approvedAddressSlot)
1545         }
1546     }
1547 
1548     // =============================================================
1549     //                      TRANSFER OPERATIONS
1550     // =============================================================
1551 
1552     /**
1553      * @dev Transfers `tokenId` from `from` to `to`.
1554      *
1555      * Requirements:
1556      *
1557      * - `from` cannot be the zero address.
1558      * - `to` cannot be the zero address.
1559      * - `tokenId` token must be owned by `from`.
1560      * - If the caller is not `from`, it must be approved to move this token
1561      * by either {approve} or {setApprovalForAll}.
1562      *
1563      * Emits a {Transfer} event.
1564      */
1565     function transferFrom(
1566         address from,
1567         address to,
1568         uint256 tokenId
1569     ) public payable virtual override {
1570         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1571 
1572         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1573 
1574         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1575 
1576         // The nested ifs save around 20+ gas over a compound boolean condition.
1577         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1578             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1579 
1580         if (to == address(0)) revert TransferToZeroAddress();
1581 
1582         _beforeTokenTransfers(from, to, tokenId, 1);
1583 
1584         // Clear approvals from the previous owner.
1585         assembly {
1586             if approvedAddress {
1587                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1588                 sstore(approvedAddressSlot, 0)
1589             }
1590         }
1591 
1592         // Underflow of the sender's balance is impossible because we check for
1593         // ownership above and the recipient's balance can't realistically overflow.
1594         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1595         unchecked {
1596             // We can directly increment and decrement the balances.
1597             --_packedAddressData[from]; // Updates: `balance -= 1`.
1598             ++_packedAddressData[to]; // Updates: `balance += 1`.
1599 
1600             // Updates:
1601             // - `address` to the next owner.
1602             // - `startTimestamp` to the timestamp of transfering.
1603             // - `burned` to `false`.
1604             // - `nextInitialized` to `true`.
1605             _packedOwnerships[tokenId] = _packOwnershipData(
1606                 to,
1607                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1608             );
1609 
1610             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1611             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1612                 uint256 nextTokenId = tokenId + 1;
1613                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1614                 if (_packedOwnerships[nextTokenId] == 0) {
1615                     // If the next slot is within bounds.
1616                     if (nextTokenId != _currentIndex) {
1617                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1618                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1619                     }
1620                 }
1621             }
1622         }
1623 
1624         emit Transfer(from, to, tokenId);
1625         _afterTokenTransfers(from, to, tokenId, 1);
1626     }
1627 
1628     /**
1629      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1630      */
1631     function safeTransferFrom(
1632         address from,
1633         address to,
1634         uint256 tokenId
1635     ) public payable virtual override {
1636         safeTransferFrom(from, to, tokenId, '');
1637     }
1638 
1639     /**
1640      * @dev Safely transfers `tokenId` token from `from` to `to`.
1641      *
1642      * Requirements:
1643      *
1644      * - `from` cannot be the zero address.
1645      * - `to` cannot be the zero address.
1646      * - `tokenId` token must exist and be owned by `from`.
1647      * - If the caller is not `from`, it must be approved to move this token
1648      * by either {approve} or {setApprovalForAll}.
1649      * - If `to` refers to a smart contract, it must implement
1650      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1651      *
1652      * Emits a {Transfer} event.
1653      */
1654     function safeTransferFrom(
1655         address from,
1656         address to,
1657         uint256 tokenId,
1658         bytes memory _data
1659     ) public payable virtual override {
1660         transferFrom(from, to, tokenId);
1661         if (to.code.length != 0)
1662             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1663                 revert TransferToNonERC721ReceiverImplementer();
1664             }
1665     }
1666 
1667     /**
1668      * @dev Hook that is called before a set of serially-ordered token IDs
1669      * are about to be transferred. This includes minting.
1670      * And also called before burning one token.
1671      *
1672      * `startTokenId` - the first token ID to be transferred.
1673      * `quantity` - the amount to be transferred.
1674      *
1675      * Calling conditions:
1676      *
1677      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1678      * transferred to `to`.
1679      * - When `from` is zero, `tokenId` will be minted for `to`.
1680      * - When `to` is zero, `tokenId` will be burned by `from`.
1681      * - `from` and `to` are never both zero.
1682      */
1683     function _beforeTokenTransfers(
1684         address from,
1685         address to,
1686         uint256 startTokenId,
1687         uint256 quantity
1688     ) internal virtual {}
1689 
1690     /**
1691      * @dev Hook that is called after a set of serially-ordered token IDs
1692      * have been transferred. This includes minting.
1693      * And also called after one token has been burned.
1694      *
1695      * `startTokenId` - the first token ID to be transferred.
1696      * `quantity` - the amount to be transferred.
1697      *
1698      * Calling conditions:
1699      *
1700      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1701      * transferred to `to`.
1702      * - When `from` is zero, `tokenId` has been minted for `to`.
1703      * - When `to` is zero, `tokenId` has been burned by `from`.
1704      * - `from` and `to` are never both zero.
1705      */
1706     function _afterTokenTransfers(
1707         address from,
1708         address to,
1709         uint256 startTokenId,
1710         uint256 quantity
1711     ) internal virtual {}
1712 
1713     /**
1714      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1715      *
1716      * `from` - Previous owner of the given token ID.
1717      * `to` - Target address that will receive the token.
1718      * `tokenId` - Token ID to be transferred.
1719      * `_data` - Optional data to send along with the call.
1720      *
1721      * Returns whether the call correctly returned the expected magic value.
1722      */
1723     function _checkContractOnERC721Received(
1724         address from,
1725         address to,
1726         uint256 tokenId,
1727         bytes memory _data
1728     ) private returns (bool) {
1729         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1730             bytes4 retval
1731         ) {
1732             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1733         } catch (bytes memory reason) {
1734             if (reason.length == 0) {
1735                 revert TransferToNonERC721ReceiverImplementer();
1736             } else {
1737                 assembly {
1738                     revert(add(32, reason), mload(reason))
1739                 }
1740             }
1741         }
1742     }
1743 
1744     // =============================================================
1745     //                        MINT OPERATIONS
1746     // =============================================================
1747 
1748     /**
1749      * @dev Mints `quantity` tokens and transfers them to `to`.
1750      *
1751      * Requirements:
1752      *
1753      * - `to` cannot be the zero address.
1754      * - `quantity` must be greater than 0.
1755      *
1756      * Emits a {Transfer} event for each mint.
1757      */
1758     function _mint(address to, uint256 quantity) internal virtual {
1759         uint256 startTokenId = _currentIndex;
1760         if (quantity == 0) revert MintZeroQuantity();
1761 
1762         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1763 
1764         // Overflows are incredibly unrealistic.
1765         // `balance` and `numberMinted` have a maximum limit of 2**64.
1766         // `tokenId` has a maximum limit of 2**256.
1767         unchecked {
1768             // Updates:
1769             // - `balance += quantity`.
1770             // - `numberMinted += quantity`.
1771             //
1772             // We can directly add to the `balance` and `numberMinted`.
1773             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1774 
1775             // Updates:
1776             // - `address` to the owner.
1777             // - `startTimestamp` to the timestamp of minting.
1778             // - `burned` to `false`.
1779             // - `nextInitialized` to `quantity == 1`.
1780             _packedOwnerships[startTokenId] = _packOwnershipData(
1781                 to,
1782                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1783             );
1784 
1785             uint256 toMasked;
1786             uint256 end = startTokenId + quantity;
1787 
1788             // Use assembly to loop and emit the `Transfer` event for gas savings.
1789             // The duplicated `log4` removes an extra check and reduces stack juggling.
1790             // The assembly, together with the surrounding Solidity code, have been
1791             // delicately arranged to nudge the compiler into producing optimized opcodes.
1792             assembly {
1793                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1794                 toMasked := and(to, _BITMASK_ADDRESS)
1795                 // Emit the `Transfer` event.
1796                 log4(
1797                     0, // Start of data (0, since no data).
1798                     0, // End of data (0, since no data).
1799                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1800                     0, // `address(0)`.
1801                     toMasked, // `to`.
1802                     startTokenId // `tokenId`.
1803                 )
1804 
1805                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1806                 // that overflows uint256 will make the loop run out of gas.
1807                 // The compiler will optimize the `iszero` away for performance.
1808                 for {
1809                     let tokenId := add(startTokenId, 1)
1810                 } iszero(eq(tokenId, end)) {
1811                     tokenId := add(tokenId, 1)
1812                 } {
1813                     // Emit the `Transfer` event. Similar to above.
1814                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1815                 }
1816             }
1817             if (toMasked == 0) revert MintToZeroAddress();
1818 
1819             _currentIndex = end;
1820         }
1821         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1822     }
1823 
1824     /**
1825      * @dev Mints `quantity` tokens and transfers them to `to`.
1826      *
1827      * This function is intended for efficient minting only during contract creation.
1828      *
1829      * It emits only one {ConsecutiveTransfer} as defined in
1830      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1831      * instead of a sequence of {Transfer} event(s).
1832      *
1833      * Calling this function outside of contract creation WILL make your contract
1834      * non-compliant with the ERC721 standard.
1835      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1836      * {ConsecutiveTransfer} event is only permissible during contract creation.
1837      *
1838      * Requirements:
1839      *
1840      * - `to` cannot be the zero address.
1841      * - `quantity` must be greater than 0.
1842      *
1843      * Emits a {ConsecutiveTransfer} event.
1844      */
1845     function _mintERC2309(address to, uint256 quantity) internal virtual {
1846         uint256 startTokenId = _currentIndex;
1847         if (to == address(0)) revert MintToZeroAddress();
1848         if (quantity == 0) revert MintZeroQuantity();
1849         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1850 
1851         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1852 
1853         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1854         unchecked {
1855             // Updates:
1856             // - `balance += quantity`.
1857             // - `numberMinted += quantity`.
1858             //
1859             // We can directly add to the `balance` and `numberMinted`.
1860             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1861 
1862             // Updates:
1863             // - `address` to the owner.
1864             // - `startTimestamp` to the timestamp of minting.
1865             // - `burned` to `false`.
1866             // - `nextInitialized` to `quantity == 1`.
1867             _packedOwnerships[startTokenId] = _packOwnershipData(
1868                 to,
1869                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1870             );
1871 
1872             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1873 
1874             _currentIndex = startTokenId + quantity;
1875         }
1876         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1877     }
1878 
1879     /**
1880      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1881      *
1882      * Requirements:
1883      *
1884      * - If `to` refers to a smart contract, it must implement
1885      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1886      * - `quantity` must be greater than 0.
1887      *
1888      * See {_mint}.
1889      *
1890      * Emits a {Transfer} event for each mint.
1891      */
1892     function _safeMint(
1893         address to,
1894         uint256 quantity,
1895         bytes memory _data
1896     ) internal virtual {
1897         _mint(to, quantity);
1898 
1899         unchecked {
1900             if (to.code.length != 0) {
1901                 uint256 end = _currentIndex;
1902                 uint256 index = end - quantity;
1903                 do {
1904                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1905                         revert TransferToNonERC721ReceiverImplementer();
1906                     }
1907                 } while (index < end);
1908                 // Reentrancy protection.
1909                 if (_currentIndex != end) revert();
1910             }
1911         }
1912     }
1913 
1914     /**
1915      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1916      */
1917     function _safeMint(address to, uint256 quantity) internal virtual {
1918         _safeMint(to, quantity, '');
1919     }
1920 
1921     // =============================================================
1922     //                        BURN OPERATIONS
1923     // =============================================================
1924 
1925     /**
1926      * @dev Equivalent to `_burn(tokenId, false)`.
1927      */
1928     function _burn(uint256 tokenId) internal virtual {
1929         _burn(tokenId, false);
1930     }
1931 
1932     /**
1933      * @dev Destroys `tokenId`.
1934      * The approval is cleared when the token is burned.
1935      *
1936      * Requirements:
1937      *
1938      * - `tokenId` must exist.
1939      *
1940      * Emits a {Transfer} event.
1941      */
1942     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1943         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1944 
1945         address from = address(uint160(prevOwnershipPacked));
1946 
1947         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1948 
1949         if (approvalCheck) {
1950             // The nested ifs save around 20+ gas over a compound boolean condition.
1951             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1952                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1953         }
1954 
1955         _beforeTokenTransfers(from, address(0), tokenId, 1);
1956 
1957         // Clear approvals from the previous owner.
1958         assembly {
1959             if approvedAddress {
1960                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1961                 sstore(approvedAddressSlot, 0)
1962             }
1963         }
1964 
1965         // Underflow of the sender's balance is impossible because we check for
1966         // ownership above and the recipient's balance can't realistically overflow.
1967         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1968         unchecked {
1969             // Updates:
1970             // - `balance -= 1`.
1971             // - `numberBurned += 1`.
1972             //
1973             // We can directly decrement the balance, and increment the number burned.
1974             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1975             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1976 
1977             // Updates:
1978             // - `address` to the last owner.
1979             // - `startTimestamp` to the timestamp of burning.
1980             // - `burned` to `true`.
1981             // - `nextInitialized` to `true`.
1982             _packedOwnerships[tokenId] = _packOwnershipData(
1983                 from,
1984                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1985             );
1986 
1987             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1988             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1989                 uint256 nextTokenId = tokenId + 1;
1990                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1991                 if (_packedOwnerships[nextTokenId] == 0) {
1992                     // If the next slot is within bounds.
1993                     if (nextTokenId != _currentIndex) {
1994                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1995                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1996                     }
1997                 }
1998             }
1999         }
2000 
2001         emit Transfer(from, address(0), tokenId);
2002         _afterTokenTransfers(from, address(0), tokenId, 1);
2003 
2004         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2005         unchecked {
2006             _burnCounter++;
2007         }
2008     }
2009 
2010     // =============================================================
2011     //                     EXTRA DATA OPERATIONS
2012     // =============================================================
2013 
2014     /**
2015      * @dev Directly sets the extra data for the ownership data `index`.
2016      */
2017     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2018         uint256 packed = _packedOwnerships[index];
2019         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2020         uint256 extraDataCasted;
2021         // Cast `extraData` with assembly to avoid redundant masking.
2022         assembly {
2023             extraDataCasted := extraData
2024         }
2025         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2026         _packedOwnerships[index] = packed;
2027     }
2028 
2029     /**
2030      * @dev Called during each token transfer to set the 24bit `extraData` field.
2031      * Intended to be overridden by the cosumer contract.
2032      *
2033      * `previousExtraData` - the value of `extraData` before transfer.
2034      *
2035      * Calling conditions:
2036      *
2037      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2038      * transferred to `to`.
2039      * - When `from` is zero, `tokenId` will be minted for `to`.
2040      * - When `to` is zero, `tokenId` will be burned by `from`.
2041      * - `from` and `to` are never both zero.
2042      */
2043     function _extraData(
2044         address from,
2045         address to,
2046         uint24 previousExtraData
2047     ) internal view virtual returns (uint24) {}
2048 
2049     /**
2050      * @dev Returns the next extra data for the packed ownership data.
2051      * The returned result is shifted into position.
2052      */
2053     function _nextExtraData(
2054         address from,
2055         address to,
2056         uint256 prevOwnershipPacked
2057     ) private view returns (uint256) {
2058         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2059         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2060     }
2061 
2062     // =============================================================
2063     //                       OTHER OPERATIONS
2064     // =============================================================
2065 
2066     /**
2067      * @dev Returns the message sender (defaults to `msg.sender`).
2068      *
2069      * If you are writing GSN compatible contracts, you need to override this function.
2070      */
2071     function _msgSenderERC721A() internal view virtual returns (address) {
2072         return msg.sender;
2073     }
2074 
2075     /**
2076      * @dev Converts a uint256 to its ASCII string decimal representation.
2077      */
2078     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2079         assembly {
2080             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2081             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2082             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2083             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2084             let m := add(mload(0x40), 0xa0)
2085             // Update the free memory pointer to allocate.
2086             mstore(0x40, m)
2087             // Assign the `str` to the end.
2088             str := sub(m, 0x20)
2089             // Zeroize the slot after the string.
2090             mstore(str, 0)
2091 
2092             // Cache the end of the memory to calculate the length later.
2093             let end := str
2094 
2095             // We write the string from rightmost digit to leftmost digit.
2096             // The following is essentially a do-while loop that also handles the zero case.
2097             // prettier-ignore
2098             for { let temp := value } 1 {} {
2099                 str := sub(str, 1)
2100                 // Write the character to the pointer.
2101                 // The ASCII index of the '0' character is 48.
2102                 mstore8(str, add(48, mod(temp, 10)))
2103                 // Keep dividing `temp` until zero.
2104                 temp := div(temp, 10)
2105                 // prettier-ignore
2106                 if iszero(temp) { break }
2107             }
2108 
2109             let length := sub(end, str)
2110             // Move the pointer 32 bytes leftwards to make room for the length.
2111             str := sub(str, 0x20)
2112             // Store the length.
2113             mstore(str, length)
2114         }
2115     }
2116 }
2117 
2118 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2119 
2120 
2121 // ERC721A Contracts v4.2.3
2122 // Creator: Chiru Labs
2123 
2124 pragma solidity ^0.8.4;
2125 
2126 
2127 
2128 /**
2129  * @title ERC721AQueryable.
2130  *
2131  * @dev ERC721A subclass with convenience query functions.
2132  */
2133 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2134     /**
2135      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2136      *
2137      * If the `tokenId` is out of bounds:
2138      *
2139      * - `addr = address(0)`
2140      * - `startTimestamp = 0`
2141      * - `burned = false`
2142      * - `extraData = 0`
2143      *
2144      * If the `tokenId` is burned:
2145      *
2146      * - `addr = <Address of owner before token was burned>`
2147      * - `startTimestamp = <Timestamp when token was burned>`
2148      * - `burned = true`
2149      * - `extraData = <Extra data when token was burned>`
2150      *
2151      * Otherwise:
2152      *
2153      * - `addr = <Address of owner>`
2154      * - `startTimestamp = <Timestamp of start of ownership>`
2155      * - `burned = false`
2156      * - `extraData = <Extra data at start of ownership>`
2157      */
2158     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2159         TokenOwnership memory ownership;
2160         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2161             return ownership;
2162         }
2163         ownership = _ownershipAt(tokenId);
2164         if (ownership.burned) {
2165             return ownership;
2166         }
2167         return _ownershipOf(tokenId);
2168     }
2169 
2170     /**
2171      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2172      * See {ERC721AQueryable-explicitOwnershipOf}
2173      */
2174     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2175         external
2176         view
2177         virtual
2178         override
2179         returns (TokenOwnership[] memory)
2180     {
2181         unchecked {
2182             uint256 tokenIdsLength = tokenIds.length;
2183             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2184             for (uint256 i; i != tokenIdsLength; ++i) {
2185                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2186             }
2187             return ownerships;
2188         }
2189     }
2190 
2191     /**
2192      * @dev Returns an array of token IDs owned by `owner`,
2193      * in the range [`start`, `stop`)
2194      * (i.e. `start <= tokenId < stop`).
2195      *
2196      * This function allows for tokens to be queried if the collection
2197      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2198      *
2199      * Requirements:
2200      *
2201      * - `start < stop`
2202      */
2203     function tokensOfOwnerIn(
2204         address owner,
2205         uint256 start,
2206         uint256 stop
2207     ) external view virtual override returns (uint256[] memory) {
2208         unchecked {
2209             if (start >= stop) revert InvalidQueryRange();
2210             uint256 tokenIdsIdx;
2211             uint256 stopLimit = _nextTokenId();
2212             // Set `start = max(start, _startTokenId())`.
2213             if (start < _startTokenId()) {
2214                 start = _startTokenId();
2215             }
2216             // Set `stop = min(stop, stopLimit)`.
2217             if (stop > stopLimit) {
2218                 stop = stopLimit;
2219             }
2220             uint256 tokenIdsMaxLength = balanceOf(owner);
2221             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2222             // to cater for cases where `balanceOf(owner)` is too big.
2223             if (start < stop) {
2224                 uint256 rangeLength = stop - start;
2225                 if (rangeLength < tokenIdsMaxLength) {
2226                     tokenIdsMaxLength = rangeLength;
2227                 }
2228             } else {
2229                 tokenIdsMaxLength = 0;
2230             }
2231             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2232             if (tokenIdsMaxLength == 0) {
2233                 return tokenIds;
2234             }
2235             // We need to call `explicitOwnershipOf(start)`,
2236             // because the slot at `start` may not be initialized.
2237             TokenOwnership memory ownership = explicitOwnershipOf(start);
2238             address currOwnershipAddr;
2239             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2240             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2241             if (!ownership.burned) {
2242                 currOwnershipAddr = ownership.addr;
2243             }
2244             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2245                 ownership = _ownershipAt(i);
2246                 if (ownership.burned) {
2247                     continue;
2248                 }
2249                 if (ownership.addr != address(0)) {
2250                     currOwnershipAddr = ownership.addr;
2251                 }
2252                 if (currOwnershipAddr == owner) {
2253                     tokenIds[tokenIdsIdx++] = i;
2254                 }
2255             }
2256             // Downsize the array to fit.
2257             assembly {
2258                 mstore(tokenIds, tokenIdsIdx)
2259             }
2260             return tokenIds;
2261         }
2262     }
2263 
2264     /**
2265      * @dev Returns an array of token IDs owned by `owner`.
2266      *
2267      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2268      * It is meant to be called off-chain.
2269      *
2270      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2271      * multiple smaller scans if the collection is large enough to cause
2272      * an out-of-gas error (10K collections should be fine).
2273      */
2274     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2275         unchecked {
2276             uint256 tokenIdsIdx;
2277             address currOwnershipAddr;
2278             uint256 tokenIdsLength = balanceOf(owner);
2279             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2280             TokenOwnership memory ownership;
2281             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2282                 ownership = _ownershipAt(i);
2283                 if (ownership.burned) {
2284                     continue;
2285                 }
2286                 if (ownership.addr != address(0)) {
2287                     currOwnershipAddr = ownership.addr;
2288                 }
2289                 if (currOwnershipAddr == owner) {
2290                     tokenIds[tokenIdsIdx++] = i;
2291                 }
2292             }
2293             return tokenIds;
2294         }
2295     }
2296 }
2297 
2298 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
2299 
2300 
2301 // ERC721A Contracts v4.2.3
2302 // Creator: Chiru Labs
2303 
2304 pragma solidity ^0.8.4;
2305 
2306 
2307 
2308 /**
2309  * @title ERC721ABurnable.
2310  *
2311  * @dev ERC721A token that can be irreversibly burned (destroyed).
2312  */
2313 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
2314     /**
2315      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2316      *
2317      * Requirements:
2318      *
2319      * - The caller must own `tokenId` or be an approved operator.
2320      */
2321     function burn(uint256 tokenId) public virtual override {
2322         _burn(tokenId, true);
2323     }
2324 }
2325 
2326 // File: UtopiaNFT.sol
2327 
2328 
2329 // creator : Jason Siauw / jason9071.eth
2330 // contact : jasonsiauw90712223@gmail.com
2331 
2332 pragma solidity ^0.8.4;
2333 
2334 
2335 
2336 
2337 
2338 
2339 
2340 
2341 contract UtopiaNFT is ERC721AQueryable, Ownable {
2342     using Strings for uint256;
2343 
2344     string public hashProof;
2345     string public baseURI;
2346     uint256 public maxSupply;
2347     uint256 public mintingHardCap;
2348     uint256 public whitelistHardCap;
2349     bytes32 public merkleRoot;
2350     bool public allowWhitelistMint;
2351     bool public allowPublicMint;
2352     uint256 public mintPrice;
2353 
2354     mapping( address => uint256 ) public totalBuy;
2355 
2356     event WhitelistMint( address to, uint256 quantity );
2357     event PublicMint( address to, uint256 quantity );
2358     event Airdrop( address to, uint256 quantity );
2359 
2360     constructor() ERC721A("Utopia NFT", "UTOPIA") {
2361         baseURI = "https://api.utopianft.io/hk/metadata/";
2362         maxSupply = 4570;
2363         mintingHardCap = 4370;
2364         whitelistHardCap = 2000;
2365         merkleRoot = 0x97aa756f15e1077c76b2af6aec065c2772f1295df0d4448bef0cd343bc617823;
2366         allowWhitelistMint = false;
2367         allowPublicMint = false;
2368         mintPrice = 0.022 ether;
2369         hashProof = "e324296e37b7a1c98eeb69ca118a41b1dd39da815c87342a5f7f711cadaf424d";
2370     }
2371 
2372     // modifier //
2373 
2374     modifier notContract() {
2375         require(!_isContract(msg.sender), "contract not allowed");
2376         require(msg.sender == tx.origin, "proxy contract not allowed");
2377 
2378         _;
2379     }
2380 
2381     // modifier //
2382 
2383     // main function //
2384 
2385     function whitelistMint(
2386         address to,
2387         uint256 quantity,
2388         bytes32[] calldata proof
2389     ) external payable notContract {
2390         require( to == msg.sender, "not the same caller" );
2391         require( quantity > 0, "quantity can not smaller than 1" );
2392         require( quantity < 6, "quantity can not bigger than 5" );
2393         require( totalSupply() + quantity <= whitelistHardCap, "out of whitelist hard cap" );
2394         require( totalSupply() + quantity <= mintingHardCap, "out of minting hard cap" );
2395         require( totalBuy[to] + quantity < 6, "out of max quantity for each address" );
2396         require( allowWhitelistMint, "not allow to whitelist mint now" );
2397         require( isWhitelist( to, proof, merkleRoot ), "not in whitelist" );
2398 
2399         if ( totalBuy[to] == 0 ) {
2400             require( msg.value >= ( quantity * mintPrice ) - mintPrice , "not enough ether(1)" );
2401         }
2402         else {
2403             require( msg.value >= quantity * mintPrice , "not enough ether(2)" );
2404         }
2405 
2406         totalBuy[to] = totalBuy[to] + quantity;
2407         _mint(to, quantity);
2408 
2409         emit WhitelistMint(to, quantity);
2410     }
2411 
2412     function publicMint(
2413         address to,
2414         uint256 quantity
2415     ) external payable notContract {
2416         require( to == msg.sender, "not the same caller" );
2417         require( quantity > 0, "quantity can not smaller than 1" );
2418         require( quantity < 6, "quantity can not bigger than 5" );
2419         require( totalSupply() + quantity <= mintingHardCap, "out of minting hard cap" );
2420         require( totalBuy[to] + quantity < 6, "out of max quantity for each address" );
2421         require( allowPublicMint, "not allow to public mint now" );
2422         require( msg.value >= quantity * mintPrice , "not enough ether" );
2423 
2424         totalBuy[to] = totalBuy[to] + quantity;
2425         _mint(to, quantity);
2426 
2427         emit PublicMint(to, quantity);
2428     }
2429 
2430     function airdrop( 
2431         address to,
2432         uint256 quantity
2433     ) external onlyOwner {
2434         require( totalSupply() + quantity <= maxSupply, "out of max supply" );
2435         require( quantity > 0, "quantity can not small than 1" );
2436 
2437         _mint(to, quantity);
2438 
2439         emit Airdrop(to, quantity);
2440     }
2441 
2442     function tokenURI(
2443         uint256 tokenId
2444     ) public view virtual override returns (string memory) {
2445         require(_exists(tokenId), "Token does not exist.");
2446 
2447         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
2448     }
2449 
2450     // main function //
2451 
2452     // admin function //
2453 
2454     function withdraw() external onlyOwner {
2455         require(address(this).balance > 0, "insufficient balance");
2456         payable(msg.sender).transfer(address(this).balance);
2457     }
2458 
2459     function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
2460         maxSupply = newMaxSupply;
2461     }
2462 
2463     function setMerkleRoot(bytes32 newMerkleRoot) external onlyOwner {
2464         merkleRoot = newMerkleRoot;
2465     }
2466 
2467     function filpAllowWhitelistMint() external onlyOwner {
2468         allowWhitelistMint = !allowWhitelistMint;
2469     }
2470 
2471     function filpAllowPublicMint() external onlyOwner {
2472         allowPublicMint = !allowPublicMint;
2473     }
2474 
2475     // admin function //
2476 
2477     // prop function //
2478 
2479     function leaf(
2480         address _account
2481     ) internal pure returns (bytes32) {
2482         return keccak256(abi.encodePacked(_account));
2483     }
2484 
2485     function isWhitelist(
2486         address adr,
2487         bytes32[] calldata proof,
2488         bytes32 root
2489     ) internal pure returns (bool) {
2490         return MerkleProof.verify(proof, root, leaf(adr));
2491     }
2492 
2493     function _isContract(
2494         address _addr
2495     ) internal view returns (bool) {
2496         uint size;
2497         assembly { size := extcodesize(_addr) }
2498         return size > 0;
2499     }
2500 
2501     // prop function //
2502 }