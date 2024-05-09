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
79 // File: @openzeppelin/contracts/utils/Context.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes calldata) {
102         return msg.data;
103     }
104 }
105 
106 // File: @openzeppelin/contracts/access/Ownable.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 abstract contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor() {
135         _transferOwnership(_msgSender());
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         _checkOwner();
143         _;
144     }
145 
146     /**
147      * @dev Returns the address of the current owner.
148      */
149     function owner() public view virtual returns (address) {
150         return _owner;
151     }
152 
153     /**
154      * @dev Throws if the sender is not the owner.
155      */
156     function _checkOwner() internal view virtual {
157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         _transferOwnership(address(0));
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         _transferOwnership(newOwner);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Internal function without access restriction.
183      */
184     function _transferOwnership(address newOwner) internal virtual {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
192 
193 
194 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev These functions deal with verification of Merkle Tree proofs.
200  *
201  * The proofs can be generated using the JavaScript library
202  * https://github.com/miguelmota/merkletreejs[merkletreejs].
203  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
204  *
205  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
206  *
207  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
208  * hashing, or use a hash function other than keccak256 for hashing leaves.
209  * This is because the concatenation of a sorted pair of internal nodes in
210  * the merkle tree could be reinterpreted as a leaf value.
211  */
212 library MerkleProof {
213     /**
214      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
215      * defined by `root`. For this, a `proof` must be provided, containing
216      * sibling hashes on the branch from the leaf to the root of the tree. Each
217      * pair of leaves and each pair of pre-images are assumed to be sorted.
218      */
219     function verify(
220         bytes32[] memory proof,
221         bytes32 root,
222         bytes32 leaf
223     ) internal pure returns (bool) {
224         return processProof(proof, leaf) == root;
225     }
226 
227     /**
228      * @dev Calldata version of {verify}
229      *
230      * _Available since v4.7._
231      */
232     function verifyCalldata(
233         bytes32[] calldata proof,
234         bytes32 root,
235         bytes32 leaf
236     ) internal pure returns (bool) {
237         return processProofCalldata(proof, leaf) == root;
238     }
239 
240     /**
241      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
242      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
243      * hash matches the root of the tree. When processing the proof, the pairs
244      * of leafs & pre-images are assumed to be sorted.
245      *
246      * _Available since v4.4._
247      */
248     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
249         bytes32 computedHash = leaf;
250         for (uint256 i = 0; i < proof.length; i++) {
251             computedHash = _hashPair(computedHash, proof[i]);
252         }
253         return computedHash;
254     }
255 
256     /**
257      * @dev Calldata version of {processProof}
258      *
259      * _Available since v4.7._
260      */
261     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
262         bytes32 computedHash = leaf;
263         for (uint256 i = 0; i < proof.length; i++) {
264             computedHash = _hashPair(computedHash, proof[i]);
265         }
266         return computedHash;
267     }
268 
269     /**
270      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
271      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
272      *
273      * _Available since v4.7._
274      */
275     function multiProofVerify(
276         bytes32[] memory proof,
277         bool[] memory proofFlags,
278         bytes32 root,
279         bytes32[] memory leaves
280     ) internal pure returns (bool) {
281         return processMultiProof(proof, proofFlags, leaves) == root;
282     }
283 
284     /**
285      * @dev Calldata version of {multiProofVerify}
286      *
287      * _Available since v4.7._
288      */
289     function multiProofVerifyCalldata(
290         bytes32[] calldata proof,
291         bool[] calldata proofFlags,
292         bytes32 root,
293         bytes32[] memory leaves
294     ) internal pure returns (bool) {
295         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
296     }
297 
298     /**
299      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
300      * consuming from one or the other at each step according to the instructions given by
301      * `proofFlags`.
302      *
303      * _Available since v4.7._
304      */
305     function processMultiProof(
306         bytes32[] memory proof,
307         bool[] memory proofFlags,
308         bytes32[] memory leaves
309     ) internal pure returns (bytes32 merkleRoot) {
310         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
311         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
312         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
313         // the merkle tree.
314         uint256 leavesLen = leaves.length;
315         uint256 totalHashes = proofFlags.length;
316 
317         // Check proof validity.
318         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
319 
320         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
321         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
322         bytes32[] memory hashes = new bytes32[](totalHashes);
323         uint256 leafPos = 0;
324         uint256 hashPos = 0;
325         uint256 proofPos = 0;
326         // At each step, we compute the next hash using two values:
327         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
328         //   get the next hash.
329         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
330         //   `proof` array.
331         for (uint256 i = 0; i < totalHashes; i++) {
332             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
333             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
334             hashes[i] = _hashPair(a, b);
335         }
336 
337         if (totalHashes > 0) {
338             return hashes[totalHashes - 1];
339         } else if (leavesLen > 0) {
340             return leaves[0];
341         } else {
342             return proof[0];
343         }
344     }
345 
346     /**
347      * @dev Calldata version of {processMultiProof}
348      *
349      * _Available since v4.7._
350      */
351     function processMultiProofCalldata(
352         bytes32[] calldata proof,
353         bool[] calldata proofFlags,
354         bytes32[] memory leaves
355     ) internal pure returns (bytes32 merkleRoot) {
356         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
357         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
358         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
359         // the merkle tree.
360         uint256 leavesLen = leaves.length;
361         uint256 totalHashes = proofFlags.length;
362 
363         // Check proof validity.
364         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
365 
366         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
367         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
368         bytes32[] memory hashes = new bytes32[](totalHashes);
369         uint256 leafPos = 0;
370         uint256 hashPos = 0;
371         uint256 proofPos = 0;
372         // At each step, we compute the next hash using two values:
373         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
374         //   get the next hash.
375         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
376         //   `proof` array.
377         for (uint256 i = 0; i < totalHashes; i++) {
378             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
379             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
380             hashes[i] = _hashPair(a, b);
381         }
382 
383         if (totalHashes > 0) {
384             return hashes[totalHashes - 1];
385         } else if (leavesLen > 0) {
386             return leaves[0];
387         } else {
388             return proof[0];
389         }
390     }
391 
392     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
393         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
394     }
395 
396     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
397         /// @solidity memory-safe-assembly
398         assembly {
399             mstore(0x00, a)
400             mstore(0x20, b)
401             value := keccak256(0x00, 0x40)
402         }
403     }
404 }
405 
406 // File: erc721a/contracts/IERC721A.sol
407 
408 
409 // ERC721A Contracts v4.2.2
410 // Creator: Chiru Labs
411 
412 pragma solidity ^0.8.4;
413 
414 /**
415  * @dev Interface of ERC721A.
416  */
417 interface IERC721A {
418     /**
419      * The caller must own the token or be an approved operator.
420      */
421     error ApprovalCallerNotOwnerNorApproved();
422 
423     /**
424      * The token does not exist.
425      */
426     error ApprovalQueryForNonexistentToken();
427 
428     /**
429      * The caller cannot approve to their own address.
430      */
431     error ApproveToCaller();
432 
433     /**
434      * Cannot query the balance for the zero address.
435      */
436     error BalanceQueryForZeroAddress();
437 
438     /**
439      * Cannot mint to the zero address.
440      */
441     error MintToZeroAddress();
442 
443     /**
444      * The quantity of tokens minted must be more than zero.
445      */
446     error MintZeroQuantity();
447 
448     /**
449      * The token does not exist.
450      */
451     error OwnerQueryForNonexistentToken();
452 
453     /**
454      * The caller must own the token or be an approved operator.
455      */
456     error TransferCallerNotOwnerNorApproved();
457 
458     /**
459      * The token must be owned by `from`.
460      */
461     error TransferFromIncorrectOwner();
462 
463     /**
464      * Cannot safely transfer to a contract that does not implement the
465      * ERC721Receiver interface.
466      */
467     error TransferToNonERC721ReceiverImplementer();
468 
469     /**
470      * Cannot transfer to the zero address.
471      */
472     error TransferToZeroAddress();
473 
474     /**
475      * The token does not exist.
476      */
477     error URIQueryForNonexistentToken();
478 
479     /**
480      * The `quantity` minted with ERC2309 exceeds the safety limit.
481      */
482     error MintERC2309QuantityExceedsLimit();
483 
484     /**
485      * The `extraData` cannot be set on an unintialized ownership slot.
486      */
487     error OwnershipNotInitializedForExtraData();
488 
489     // =============================================================
490     //                            STRUCTS
491     // =============================================================
492 
493     struct TokenOwnership {
494         // The address of the owner.
495         address addr;
496         // Stores the start time of ownership with minimal overhead for tokenomics.
497         uint64 startTimestamp;
498         // Whether the token has been burned.
499         bool burned;
500         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
501         uint24 extraData;
502     }
503 
504     // =============================================================
505     //                         TOKEN COUNTERS
506     // =============================================================
507 
508     /**
509      * @dev Returns the total number of tokens in existence.
510      * Burned tokens will reduce the count.
511      * To get the total number of tokens minted, please see {_totalMinted}.
512      */
513     function totalSupply() external view returns (uint256);
514 
515     // =============================================================
516     //                            IERC165
517     // =============================================================
518 
519     /**
520      * @dev Returns true if this contract implements the interface defined by
521      * `interfaceId`. See the corresponding
522      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
523      * to learn more about how these ids are created.
524      *
525      * This function call must use less than 30000 gas.
526      */
527     function supportsInterface(bytes4 interfaceId) external view returns (bool);
528 
529     // =============================================================
530     //                            IERC721
531     // =============================================================
532 
533     /**
534      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
535      */
536     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
537 
538     /**
539      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
540      */
541     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
542 
543     /**
544      * @dev Emitted when `owner` enables or disables
545      * (`approved`) `operator` to manage all of its assets.
546      */
547     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
548 
549     /**
550      * @dev Returns the number of tokens in `owner`'s account.
551      */
552     function balanceOf(address owner) external view returns (uint256 balance);
553 
554     /**
555      * @dev Returns the owner of the `tokenId` token.
556      *
557      * Requirements:
558      *
559      * - `tokenId` must exist.
560      */
561     function ownerOf(uint256 tokenId) external view returns (address owner);
562 
563     /**
564      * @dev Safely transfers `tokenId` token from `from` to `to`,
565      * checking first that contract recipients are aware of the ERC721 protocol
566      * to prevent tokens from being forever locked.
567      *
568      * Requirements:
569      *
570      * - `from` cannot be the zero address.
571      * - `to` cannot be the zero address.
572      * - `tokenId` token must exist and be owned by `from`.
573      * - If the caller is not `from`, it must be have been allowed to move
574      * this token by either {approve} or {setApprovalForAll}.
575      * - If `to` refers to a smart contract, it must implement
576      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
577      *
578      * Emits a {Transfer} event.
579      */
580     function safeTransferFrom(
581         address from,
582         address to,
583         uint256 tokenId,
584         bytes calldata data
585     ) external;
586 
587     /**
588      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external;
595 
596     /**
597      * @dev Transfers `tokenId` from `from` to `to`.
598      *
599      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
600      * whenever possible.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must be owned by `from`.
607      * - If the caller is not `from`, it must be approved to move this token
608      * by either {approve} or {setApprovalForAll}.
609      *
610      * Emits a {Transfer} event.
611      */
612     function transferFrom(
613         address from,
614         address to,
615         uint256 tokenId
616     ) external;
617 
618     /**
619      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
620      * The approval is cleared when the token is transferred.
621      *
622      * Only a single account can be approved at a time, so approving the
623      * zero address clears previous approvals.
624      *
625      * Requirements:
626      *
627      * - The caller must own the token or be an approved operator.
628      * - `tokenId` must exist.
629      *
630      * Emits an {Approval} event.
631      */
632     function approve(address to, uint256 tokenId) external;
633 
634     /**
635      * @dev Approve or remove `operator` as an operator for the caller.
636      * Operators can call {transferFrom} or {safeTransferFrom}
637      * for any token owned by the caller.
638      *
639      * Requirements:
640      *
641      * - The `operator` cannot be the caller.
642      *
643      * Emits an {ApprovalForAll} event.
644      */
645     function setApprovalForAll(address operator, bool _approved) external;
646 
647     /**
648      * @dev Returns the account approved for `tokenId` token.
649      *
650      * Requirements:
651      *
652      * - `tokenId` must exist.
653      */
654     function getApproved(uint256 tokenId) external view returns (address operator);
655 
656     /**
657      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
658      *
659      * See {setApprovalForAll}.
660      */
661     function isApprovedForAll(address owner, address operator) external view returns (bool);
662 
663     // =============================================================
664     //                        IERC721Metadata
665     // =============================================================
666 
667     /**
668      * @dev Returns the token collection name.
669      */
670     function name() external view returns (string memory);
671 
672     /**
673      * @dev Returns the token collection symbol.
674      */
675     function symbol() external view returns (string memory);
676 
677     /**
678      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
679      */
680     function tokenURI(uint256 tokenId) external view returns (string memory);
681 
682     // =============================================================
683     //                           IERC2309
684     // =============================================================
685 
686     /**
687      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
688      * (inclusive) is transferred from `from` to `to`, as defined in the
689      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
690      *
691      * See {_mintERC2309} for more details.
692      */
693     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
694 }
695 
696 // File: erc721a/contracts/ERC721A.sol
697 
698 
699 // ERC721A Contracts v4.2.2
700 // Creator: Chiru Labs
701 
702 pragma solidity ^0.8.4;
703 
704 
705 /**
706  * @dev Interface of ERC721 token receiver.
707  */
708 interface ERC721A__IERC721Receiver {
709     function onERC721Received(
710         address operator,
711         address from,
712         uint256 tokenId,
713         bytes calldata data
714     ) external returns (bytes4);
715 }
716 
717 /**
718  * @title ERC721A
719  *
720  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
721  * Non-Fungible Token Standard, including the Metadata extension.
722  * Optimized for lower gas during batch mints.
723  *
724  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
725  * starting from `_startTokenId()`.
726  *
727  * Assumptions:
728  *
729  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
730  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
731  */
732 contract ERC721A is IERC721A {
733     // Reference type for token approval.
734     struct TokenApprovalRef {
735         address value;
736     }
737 
738     // =============================================================
739     //                           CONSTANTS
740     // =============================================================
741 
742     // Mask of an entry in packed address data.
743     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
744 
745     // The bit position of `numberMinted` in packed address data.
746     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
747 
748     // The bit position of `numberBurned` in packed address data.
749     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
750 
751     // The bit position of `aux` in packed address data.
752     uint256 private constant _BITPOS_AUX = 192;
753 
754     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
755     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
756 
757     // The bit position of `startTimestamp` in packed ownership.
758     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
759 
760     // The bit mask of the `burned` bit in packed ownership.
761     uint256 private constant _BITMASK_BURNED = 1 << 224;
762 
763     // The bit position of the `nextInitialized` bit in packed ownership.
764     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
765 
766     // The bit mask of the `nextInitialized` bit in packed ownership.
767     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
768 
769     // The bit position of `extraData` in packed ownership.
770     uint256 private constant _BITPOS_EXTRA_DATA = 232;
771 
772     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
773     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
774 
775     // The mask of the lower 160 bits for addresses.
776     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
777 
778     // The maximum `quantity` that can be minted with {_mintERC2309}.
779     // This limit is to prevent overflows on the address data entries.
780     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
781     // is required to cause an overflow, which is unrealistic.
782     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
783 
784     // The `Transfer` event signature is given by:
785     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
786     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
787         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
788 
789     // =============================================================
790     //                            STORAGE
791     // =============================================================
792 
793     // The next token ID to be minted.
794     uint256 private _currentIndex;
795 
796     // The number of tokens burned.
797     uint256 private _burnCounter;
798 
799     // Token name
800     string private _name;
801 
802     // Token symbol
803     string private _symbol;
804 
805     // Mapping from token ID to ownership details
806     // An empty struct value does not necessarily mean the token is unowned.
807     // See {_packedOwnershipOf} implementation for details.
808     //
809     // Bits Layout:
810     // - [0..159]   `addr`
811     // - [160..223] `startTimestamp`
812     // - [224]      `burned`
813     // - [225]      `nextInitialized`
814     // - [232..255] `extraData`
815     mapping(uint256 => uint256) private _packedOwnerships;
816 
817     // Mapping owner address to address data.
818     //
819     // Bits Layout:
820     // - [0..63]    `balance`
821     // - [64..127]  `numberMinted`
822     // - [128..191] `numberBurned`
823     // - [192..255] `aux`
824     mapping(address => uint256) private _packedAddressData;
825 
826     // Mapping from token ID to approved address.
827     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
828 
829     // Mapping from owner to operator approvals
830     mapping(address => mapping(address => bool)) private _operatorApprovals;
831 
832     // =============================================================
833     //                          CONSTRUCTOR
834     // =============================================================
835 
836     constructor(string memory name_, string memory symbol_) {
837         _name = name_;
838         _symbol = symbol_;
839         _currentIndex = _startTokenId();
840     }
841 
842     // =============================================================
843     //                   TOKEN COUNTING OPERATIONS
844     // =============================================================
845 
846     /**
847      * @dev Returns the starting token ID.
848      * To change the starting token ID, please override this function.
849      */
850     function _startTokenId() internal view virtual returns (uint256) {
851         return 0;
852     }
853 
854     /**
855      * @dev Returns the next token ID to be minted.
856      */
857     function _nextTokenId() internal view virtual returns (uint256) {
858         return _currentIndex;
859     }
860 
861     /**
862      * @dev Returns the total number of tokens in existence.
863      * Burned tokens will reduce the count.
864      * To get the total number of tokens minted, please see {_totalMinted}.
865      */
866     function totalSupply() public view virtual override returns (uint256) {
867         // Counter underflow is impossible as _burnCounter cannot be incremented
868         // more than `_currentIndex - _startTokenId()` times.
869         unchecked {
870             return _currentIndex - _burnCounter - _startTokenId();
871         }
872     }
873 
874     /**
875      * @dev Returns the total amount of tokens minted in the contract.
876      */
877     function _totalMinted() internal view virtual returns (uint256) {
878         // Counter underflow is impossible as `_currentIndex` does not decrement,
879         // and it is initialized to `_startTokenId()`.
880         unchecked {
881             return _currentIndex - _startTokenId();
882         }
883     }
884 
885     /**
886      * @dev Returns the total number of tokens burned.
887      */
888     function _totalBurned() internal view virtual returns (uint256) {
889         return _burnCounter;
890     }
891 
892     // =============================================================
893     //                    ADDRESS DATA OPERATIONS
894     // =============================================================
895 
896     /**
897      * @dev Returns the number of tokens in `owner`'s account.
898      */
899     function balanceOf(address owner) public view virtual override returns (uint256) {
900         if (owner == address(0)) revert BalanceQueryForZeroAddress();
901         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
902     }
903 
904     /**
905      * Returns the number of tokens minted by `owner`.
906      */
907     function _numberMinted(address owner) internal view returns (uint256) {
908         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
909     }
910 
911     /**
912      * Returns the number of tokens burned by or on behalf of `owner`.
913      */
914     function _numberBurned(address owner) internal view returns (uint256) {
915         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
916     }
917 
918     /**
919      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
920      */
921     function _getAux(address owner) internal view returns (uint64) {
922         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
923     }
924 
925     /**
926      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
927      * If there are multiple variables, please pack them into a uint64.
928      */
929     function _setAux(address owner, uint64 aux) internal virtual {
930         uint256 packed = _packedAddressData[owner];
931         uint256 auxCasted;
932         // Cast `aux` with assembly to avoid redundant masking.
933         assembly {
934             auxCasted := aux
935         }
936         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
937         _packedAddressData[owner] = packed;
938     }
939 
940     // =============================================================
941     //                            IERC165
942     // =============================================================
943 
944     /**
945      * @dev Returns true if this contract implements the interface defined by
946      * `interfaceId`. See the corresponding
947      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
948      * to learn more about how these ids are created.
949      *
950      * This function call must use less than 30000 gas.
951      */
952     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
953         // The interface IDs are constants representing the first 4 bytes
954         // of the XOR of all function selectors in the interface.
955         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
956         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
957         return
958             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
959             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
960             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
961     }
962 
963     // =============================================================
964     //                        IERC721Metadata
965     // =============================================================
966 
967     /**
968      * @dev Returns the token collection name.
969      */
970     function name() public view virtual override returns (string memory) {
971         return _name;
972     }
973 
974     /**
975      * @dev Returns the token collection symbol.
976      */
977     function symbol() public view virtual override returns (string memory) {
978         return _symbol;
979     }
980 
981     /**
982      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
983      */
984     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
985         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
986 
987         string memory baseURI = _baseURI();
988         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
989     }
990 
991     /**
992      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
993      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
994      * by default, it can be overridden in child contracts.
995      */
996     function _baseURI() internal view virtual returns (string memory) {
997         return '';
998     }
999 
1000     // =============================================================
1001     //                     OWNERSHIPS OPERATIONS
1002     // =============================================================
1003 
1004     /**
1005      * @dev Returns the owner of the `tokenId` token.
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must exist.
1010      */
1011     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1012         return address(uint160(_packedOwnershipOf(tokenId)));
1013     }
1014 
1015     /**
1016      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1017      * It gradually moves to O(1) as tokens get transferred around over time.
1018      */
1019     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1020         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1021     }
1022 
1023     /**
1024      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1025      */
1026     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1027         return _unpackedOwnership(_packedOwnerships[index]);
1028     }
1029 
1030     /**
1031      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1032      */
1033     function _initializeOwnershipAt(uint256 index) internal virtual {
1034         if (_packedOwnerships[index] == 0) {
1035             _packedOwnerships[index] = _packedOwnershipOf(index);
1036         }
1037     }
1038 
1039     /**
1040      * Returns the packed ownership data of `tokenId`.
1041      */
1042     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1043         uint256 curr = tokenId;
1044 
1045         unchecked {
1046             if (_startTokenId() <= curr)
1047                 if (curr < _currentIndex) {
1048                     uint256 packed = _packedOwnerships[curr];
1049                     // If not burned.
1050                     if (packed & _BITMASK_BURNED == 0) {
1051                         // Invariant:
1052                         // There will always be an initialized ownership slot
1053                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1054                         // before an unintialized ownership slot
1055                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1056                         // Hence, `curr` will not underflow.
1057                         //
1058                         // We can directly compare the packed value.
1059                         // If the address is zero, packed will be zero.
1060                         while (packed == 0) {
1061                             packed = _packedOwnerships[--curr];
1062                         }
1063                         return packed;
1064                     }
1065                 }
1066         }
1067         revert OwnerQueryForNonexistentToken();
1068     }
1069 
1070     /**
1071      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1072      */
1073     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1074         ownership.addr = address(uint160(packed));
1075         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1076         ownership.burned = packed & _BITMASK_BURNED != 0;
1077         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1078     }
1079 
1080     /**
1081      * @dev Packs ownership data into a single uint256.
1082      */
1083     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1084         assembly {
1085             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1086             owner := and(owner, _BITMASK_ADDRESS)
1087             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1088             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1089         }
1090     }
1091 
1092     /**
1093      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1094      */
1095     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1096         // For branchless setting of the `nextInitialized` flag.
1097         assembly {
1098             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1099             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1100         }
1101     }
1102 
1103     // =============================================================
1104     //                      APPROVAL OPERATIONS
1105     // =============================================================
1106 
1107     /**
1108      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1109      * The approval is cleared when the token is transferred.
1110      *
1111      * Only a single account can be approved at a time, so approving the
1112      * zero address clears previous approvals.
1113      *
1114      * Requirements:
1115      *
1116      * - The caller must own the token or be an approved operator.
1117      * - `tokenId` must exist.
1118      *
1119      * Emits an {Approval} event.
1120      */
1121     function approve(address to, uint256 tokenId) public virtual override {
1122         address owner = ownerOf(tokenId);
1123 
1124         if (_msgSenderERC721A() != owner)
1125             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1126                 revert ApprovalCallerNotOwnerNorApproved();
1127             }
1128 
1129         _tokenApprovals[tokenId].value = to;
1130         emit Approval(owner, to, tokenId);
1131     }
1132 
1133     /**
1134      * @dev Returns the account approved for `tokenId` token.
1135      *
1136      * Requirements:
1137      *
1138      * - `tokenId` must exist.
1139      */
1140     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1141         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1142 
1143         return _tokenApprovals[tokenId].value;
1144     }
1145 
1146     /**
1147      * @dev Approve or remove `operator` as an operator for the caller.
1148      * Operators can call {transferFrom} or {safeTransferFrom}
1149      * for any token owned by the caller.
1150      *
1151      * Requirements:
1152      *
1153      * - The `operator` cannot be the caller.
1154      *
1155      * Emits an {ApprovalForAll} event.
1156      */
1157     function setApprovalForAll(address operator, bool approved) public virtual override {
1158         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1159 
1160         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1161         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1162     }
1163 
1164     /**
1165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1166      *
1167      * See {setApprovalForAll}.
1168      */
1169     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1170         return _operatorApprovals[owner][operator];
1171     }
1172 
1173     /**
1174      * @dev Returns whether `tokenId` exists.
1175      *
1176      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1177      *
1178      * Tokens start existing when they are minted. See {_mint}.
1179      */
1180     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1181         return
1182             _startTokenId() <= tokenId &&
1183             tokenId < _currentIndex && // If within bounds,
1184             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1185     }
1186 
1187     /**
1188      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1189      */
1190     function _isSenderApprovedOrOwner(
1191         address approvedAddress,
1192         address owner,
1193         address msgSender
1194     ) private pure returns (bool result) {
1195         assembly {
1196             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1197             owner := and(owner, _BITMASK_ADDRESS)
1198             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1199             msgSender := and(msgSender, _BITMASK_ADDRESS)
1200             // `msgSender == owner || msgSender == approvedAddress`.
1201             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1202         }
1203     }
1204 
1205     /**
1206      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1207      */
1208     function _getApprovedSlotAndAddress(uint256 tokenId)
1209         private
1210         view
1211         returns (uint256 approvedAddressSlot, address approvedAddress)
1212     {
1213         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1214         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1215         assembly {
1216             approvedAddressSlot := tokenApproval.slot
1217             approvedAddress := sload(approvedAddressSlot)
1218         }
1219     }
1220 
1221     // =============================================================
1222     //                      TRANSFER OPERATIONS
1223     // =============================================================
1224 
1225     /**
1226      * @dev Transfers `tokenId` from `from` to `to`.
1227      *
1228      * Requirements:
1229      *
1230      * - `from` cannot be the zero address.
1231      * - `to` cannot be the zero address.
1232      * - `tokenId` token must be owned by `from`.
1233      * - If the caller is not `from`, it must be approved to move this token
1234      * by either {approve} or {setApprovalForAll}.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function transferFrom(
1239         address from,
1240         address to,
1241         uint256 tokenId
1242     ) public virtual override {
1243         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1244 
1245         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1246 
1247         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1248 
1249         // The nested ifs save around 20+ gas over a compound boolean condition.
1250         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1251             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1252 
1253         if (to == address(0)) revert TransferToZeroAddress();
1254 
1255         _beforeTokenTransfers(from, to, tokenId, 1);
1256 
1257         // Clear approvals from the previous owner.
1258         assembly {
1259             if approvedAddress {
1260                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1261                 sstore(approvedAddressSlot, 0)
1262             }
1263         }
1264 
1265         // Underflow of the sender's balance is impossible because we check for
1266         // ownership above and the recipient's balance can't realistically overflow.
1267         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1268         unchecked {
1269             // We can directly increment and decrement the balances.
1270             --_packedAddressData[from]; // Updates: `balance -= 1`.
1271             ++_packedAddressData[to]; // Updates: `balance += 1`.
1272 
1273             // Updates:
1274             // - `address` to the next owner.
1275             // - `startTimestamp` to the timestamp of transfering.
1276             // - `burned` to `false`.
1277             // - `nextInitialized` to `true`.
1278             _packedOwnerships[tokenId] = _packOwnershipData(
1279                 to,
1280                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1281             );
1282 
1283             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1284             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1285                 uint256 nextTokenId = tokenId + 1;
1286                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1287                 if (_packedOwnerships[nextTokenId] == 0) {
1288                     // If the next slot is within bounds.
1289                     if (nextTokenId != _currentIndex) {
1290                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1291                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1292                     }
1293                 }
1294             }
1295         }
1296 
1297         emit Transfer(from, to, tokenId);
1298         _afterTokenTransfers(from, to, tokenId, 1);
1299     }
1300 
1301     /**
1302      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1303      */
1304     function safeTransferFrom(
1305         address from,
1306         address to,
1307         uint256 tokenId
1308     ) public virtual override {
1309         safeTransferFrom(from, to, tokenId, '');
1310     }
1311 
1312     /**
1313      * @dev Safely transfers `tokenId` token from `from` to `to`.
1314      *
1315      * Requirements:
1316      *
1317      * - `from` cannot be the zero address.
1318      * - `to` cannot be the zero address.
1319      * - `tokenId` token must exist and be owned by `from`.
1320      * - If the caller is not `from`, it must be approved to move this token
1321      * by either {approve} or {setApprovalForAll}.
1322      * - If `to` refers to a smart contract, it must implement
1323      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1324      *
1325      * Emits a {Transfer} event.
1326      */
1327     function safeTransferFrom(
1328         address from,
1329         address to,
1330         uint256 tokenId,
1331         bytes memory _data
1332     ) public virtual override {
1333         transferFrom(from, to, tokenId);
1334         if (to.code.length != 0)
1335             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1336                 revert TransferToNonERC721ReceiverImplementer();
1337             }
1338     }
1339 
1340     /**
1341      * @dev Hook that is called before a set of serially-ordered token IDs
1342      * are about to be transferred. This includes minting.
1343      * And also called before burning one token.
1344      *
1345      * `startTokenId` - the first token ID to be transferred.
1346      * `quantity` - the amount to be transferred.
1347      *
1348      * Calling conditions:
1349      *
1350      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1351      * transferred to `to`.
1352      * - When `from` is zero, `tokenId` will be minted for `to`.
1353      * - When `to` is zero, `tokenId` will be burned by `from`.
1354      * - `from` and `to` are never both zero.
1355      */
1356     function _beforeTokenTransfers(
1357         address from,
1358         address to,
1359         uint256 startTokenId,
1360         uint256 quantity
1361     ) internal virtual {}
1362 
1363     /**
1364      * @dev Hook that is called after a set of serially-ordered token IDs
1365      * have been transferred. This includes minting.
1366      * And also called after one token has been burned.
1367      *
1368      * `startTokenId` - the first token ID to be transferred.
1369      * `quantity` - the amount to be transferred.
1370      *
1371      * Calling conditions:
1372      *
1373      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1374      * transferred to `to`.
1375      * - When `from` is zero, `tokenId` has been minted for `to`.
1376      * - When `to` is zero, `tokenId` has been burned by `from`.
1377      * - `from` and `to` are never both zero.
1378      */
1379     function _afterTokenTransfers(
1380         address from,
1381         address to,
1382         uint256 startTokenId,
1383         uint256 quantity
1384     ) internal virtual {}
1385 
1386     /**
1387      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1388      *
1389      * `from` - Previous owner of the given token ID.
1390      * `to` - Target address that will receive the token.
1391      * `tokenId` - Token ID to be transferred.
1392      * `_data` - Optional data to send along with the call.
1393      *
1394      * Returns whether the call correctly returned the expected magic value.
1395      */
1396     function _checkContractOnERC721Received(
1397         address from,
1398         address to,
1399         uint256 tokenId,
1400         bytes memory _data
1401     ) private returns (bool) {
1402         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1403             bytes4 retval
1404         ) {
1405             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1406         } catch (bytes memory reason) {
1407             if (reason.length == 0) {
1408                 revert TransferToNonERC721ReceiverImplementer();
1409             } else {
1410                 assembly {
1411                     revert(add(32, reason), mload(reason))
1412                 }
1413             }
1414         }
1415     }
1416 
1417     // =============================================================
1418     //                        MINT OPERATIONS
1419     // =============================================================
1420 
1421     /**
1422      * @dev Mints `quantity` tokens and transfers them to `to`.
1423      *
1424      * Requirements:
1425      *
1426      * - `to` cannot be the zero address.
1427      * - `quantity` must be greater than 0.
1428      *
1429      * Emits a {Transfer} event for each mint.
1430      */
1431     function _mint(address to, uint256 quantity) internal virtual {
1432         uint256 startTokenId = _currentIndex;
1433         if (quantity == 0) revert MintZeroQuantity();
1434 
1435         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1436 
1437         // Overflows are incredibly unrealistic.
1438         // `balance` and `numberMinted` have a maximum limit of 2**64.
1439         // `tokenId` has a maximum limit of 2**256.
1440         unchecked {
1441             // Updates:
1442             // - `balance += quantity`.
1443             // - `numberMinted += quantity`.
1444             //
1445             // We can directly add to the `balance` and `numberMinted`.
1446             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1447 
1448             // Updates:
1449             // - `address` to the owner.
1450             // - `startTimestamp` to the timestamp of minting.
1451             // - `burned` to `false`.
1452             // - `nextInitialized` to `quantity == 1`.
1453             _packedOwnerships[startTokenId] = _packOwnershipData(
1454                 to,
1455                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1456             );
1457 
1458             uint256 toMasked;
1459             uint256 end = startTokenId + quantity;
1460 
1461             // Use assembly to loop and emit the `Transfer` event for gas savings.
1462             assembly {
1463                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1464                 toMasked := and(to, _BITMASK_ADDRESS)
1465                 // Emit the `Transfer` event.
1466                 log4(
1467                     0, // Start of data (0, since no data).
1468                     0, // End of data (0, since no data).
1469                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1470                     0, // `address(0)`.
1471                     toMasked, // `to`.
1472                     startTokenId // `tokenId`.
1473                 )
1474 
1475                 for {
1476                     let tokenId := add(startTokenId, 1)
1477                 } iszero(eq(tokenId, end)) {
1478                     tokenId := add(tokenId, 1)
1479                 } {
1480                     // Emit the `Transfer` event. Similar to above.
1481                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1482                 }
1483             }
1484             if (toMasked == 0) revert MintToZeroAddress();
1485 
1486             _currentIndex = end;
1487         }
1488         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1489     }
1490 
1491     /**
1492      * @dev Mints `quantity` tokens and transfers them to `to`.
1493      *
1494      * This function is intended for efficient minting only during contract creation.
1495      *
1496      * It emits only one {ConsecutiveTransfer} as defined in
1497      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1498      * instead of a sequence of {Transfer} event(s).
1499      *
1500      * Calling this function outside of contract creation WILL make your contract
1501      * non-compliant with the ERC721 standard.
1502      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1503      * {ConsecutiveTransfer} event is only permissible during contract creation.
1504      *
1505      * Requirements:
1506      *
1507      * - `to` cannot be the zero address.
1508      * - `quantity` must be greater than 0.
1509      *
1510      * Emits a {ConsecutiveTransfer} event.
1511      */
1512     function _mintERC2309(address to, uint256 quantity) internal virtual {
1513         uint256 startTokenId = _currentIndex;
1514         if (to == address(0)) revert MintToZeroAddress();
1515         if (quantity == 0) revert MintZeroQuantity();
1516         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1517 
1518         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1519 
1520         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1521         unchecked {
1522             // Updates:
1523             // - `balance += quantity`.
1524             // - `numberMinted += quantity`.
1525             //
1526             // We can directly add to the `balance` and `numberMinted`.
1527             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1528 
1529             // Updates:
1530             // - `address` to the owner.
1531             // - `startTimestamp` to the timestamp of minting.
1532             // - `burned` to `false`.
1533             // - `nextInitialized` to `quantity == 1`.
1534             _packedOwnerships[startTokenId] = _packOwnershipData(
1535                 to,
1536                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1537             );
1538 
1539             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1540 
1541             _currentIndex = startTokenId + quantity;
1542         }
1543         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1544     }
1545 
1546     /**
1547      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1548      *
1549      * Requirements:
1550      *
1551      * - If `to` refers to a smart contract, it must implement
1552      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1553      * - `quantity` must be greater than 0.
1554      *
1555      * See {_mint}.
1556      *
1557      * Emits a {Transfer} event for each mint.
1558      */
1559     function _safeMint(
1560         address to,
1561         uint256 quantity,
1562         bytes memory _data
1563     ) internal virtual {
1564         _mint(to, quantity);
1565 
1566         unchecked {
1567             if (to.code.length != 0) {
1568                 uint256 end = _currentIndex;
1569                 uint256 index = end - quantity;
1570                 do {
1571                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1572                         revert TransferToNonERC721ReceiverImplementer();
1573                     }
1574                 } while (index < end);
1575                 // Reentrancy protection.
1576                 if (_currentIndex != end) revert();
1577             }
1578         }
1579     }
1580 
1581     /**
1582      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1583      */
1584     function _safeMint(address to, uint256 quantity) internal virtual {
1585         _safeMint(to, quantity, '');
1586     }
1587 
1588     // =============================================================
1589     //                        BURN OPERATIONS
1590     // =============================================================
1591 
1592     /**
1593      * @dev Equivalent to `_burn(tokenId, false)`.
1594      */
1595     function _burn(uint256 tokenId) internal virtual {
1596         _burn(tokenId, false);
1597     }
1598 
1599     /**
1600      * @dev Destroys `tokenId`.
1601      * The approval is cleared when the token is burned.
1602      *
1603      * Requirements:
1604      *
1605      * - `tokenId` must exist.
1606      *
1607      * Emits a {Transfer} event.
1608      */
1609     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1610         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1611 
1612         address from = address(uint160(prevOwnershipPacked));
1613 
1614         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1615 
1616         if (approvalCheck) {
1617             // The nested ifs save around 20+ gas over a compound boolean condition.
1618             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1619                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1620         }
1621 
1622         _beforeTokenTransfers(from, address(0), tokenId, 1);
1623 
1624         // Clear approvals from the previous owner.
1625         assembly {
1626             if approvedAddress {
1627                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1628                 sstore(approvedAddressSlot, 0)
1629             }
1630         }
1631 
1632         // Underflow of the sender's balance is impossible because we check for
1633         // ownership above and the recipient's balance can't realistically overflow.
1634         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1635         unchecked {
1636             // Updates:
1637             // - `balance -= 1`.
1638             // - `numberBurned += 1`.
1639             //
1640             // We can directly decrement the balance, and increment the number burned.
1641             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1642             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1643 
1644             // Updates:
1645             // - `address` to the last owner.
1646             // - `startTimestamp` to the timestamp of burning.
1647             // - `burned` to `true`.
1648             // - `nextInitialized` to `true`.
1649             _packedOwnerships[tokenId] = _packOwnershipData(
1650                 from,
1651                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1652             );
1653 
1654             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1655             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1656                 uint256 nextTokenId = tokenId + 1;
1657                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1658                 if (_packedOwnerships[nextTokenId] == 0) {
1659                     // If the next slot is within bounds.
1660                     if (nextTokenId != _currentIndex) {
1661                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1662                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1663                     }
1664                 }
1665             }
1666         }
1667 
1668         emit Transfer(from, address(0), tokenId);
1669         _afterTokenTransfers(from, address(0), tokenId, 1);
1670 
1671         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1672         unchecked {
1673             _burnCounter++;
1674         }
1675     }
1676 
1677     // =============================================================
1678     //                     EXTRA DATA OPERATIONS
1679     // =============================================================
1680 
1681     /**
1682      * @dev Directly sets the extra data for the ownership data `index`.
1683      */
1684     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1685         uint256 packed = _packedOwnerships[index];
1686         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1687         uint256 extraDataCasted;
1688         // Cast `extraData` with assembly to avoid redundant masking.
1689         assembly {
1690             extraDataCasted := extraData
1691         }
1692         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1693         _packedOwnerships[index] = packed;
1694     }
1695 
1696     /**
1697      * @dev Called during each token transfer to set the 24bit `extraData` field.
1698      * Intended to be overridden by the cosumer contract.
1699      *
1700      * `previousExtraData` - the value of `extraData` before transfer.
1701      *
1702      * Calling conditions:
1703      *
1704      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1705      * transferred to `to`.
1706      * - When `from` is zero, `tokenId` will be minted for `to`.
1707      * - When `to` is zero, `tokenId` will be burned by `from`.
1708      * - `from` and `to` are never both zero.
1709      */
1710     function _extraData(
1711         address from,
1712         address to,
1713         uint24 previousExtraData
1714     ) internal view virtual returns (uint24) {}
1715 
1716     /**
1717      * @dev Returns the next extra data for the packed ownership data.
1718      * The returned result is shifted into position.
1719      */
1720     function _nextExtraData(
1721         address from,
1722         address to,
1723         uint256 prevOwnershipPacked
1724     ) private view returns (uint256) {
1725         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1726         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1727     }
1728 
1729     // =============================================================
1730     //                       OTHER OPERATIONS
1731     // =============================================================
1732 
1733     /**
1734      * @dev Returns the message sender (defaults to `msg.sender`).
1735      *
1736      * If you are writing GSN compatible contracts, you need to override this function.
1737      */
1738     function _msgSenderERC721A() internal view virtual returns (address) {
1739         return msg.sender;
1740     }
1741 
1742     /**
1743      * @dev Converts a uint256 to its ASCII string decimal representation.
1744      */
1745     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1746         assembly {
1747             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1748             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1749             // We will need 1 32-byte word to store the length,
1750             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1751             str := add(mload(0x40), 0x80)
1752             // Update the free memory pointer to allocate.
1753             mstore(0x40, str)
1754 
1755             // Cache the end of the memory to calculate the length later.
1756             let end := str
1757 
1758             // We write the string from rightmost digit to leftmost digit.
1759             // The following is essentially a do-while loop that also handles the zero case.
1760             // prettier-ignore
1761             for { let temp := value } 1 {} {
1762                 str := sub(str, 1)
1763                 // Write the character to the pointer.
1764                 // The ASCII index of the '0' character is 48.
1765                 mstore8(str, add(48, mod(temp, 10)))
1766                 // Keep dividing `temp` until zero.
1767                 temp := div(temp, 10)
1768                 // prettier-ignore
1769                 if iszero(temp) { break }
1770             }
1771 
1772             let length := sub(end, str)
1773             // Move the pointer 32 bytes leftwards to make room for the length.
1774             str := sub(str, 0x20)
1775             // Store the length.
1776             mstore(str, length)
1777         }
1778     }
1779 }
1780 
1781 
1782 /**
1783  * @title Counters
1784  * @author Matt Condon (@shrugs)
1785  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1786  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1787  *
1788  * Include with `using Counters for Counters.Counter;`
1789  */
1790 library Counters {
1791     struct Counter {
1792         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1793         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1794         // this feature: see https://github.com/ethereum/solidity/issues/4637
1795         uint256 _value; // default: 0
1796     }
1797 
1798     function current(Counter storage counter) internal view returns (uint256) {
1799         return counter._value;
1800     }
1801 
1802     function increment(Counter storage counter) internal {
1803         unchecked {
1804             counter._value += 1;
1805         }
1806     }
1807 
1808     function decrement(Counter storage counter) internal {
1809         uint256 value = counter._value;
1810         require(value > 0, "Counter: decrement overflow");
1811         unchecked {
1812             counter._value = value - 1;
1813         }
1814     }
1815 
1816     function reset(Counter storage counter) internal {
1817         counter._value = 0;
1818     }
1819 }
1820 
1821 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1822 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1823 
1824 interface IOperatorFilterRegistry {
1825     /**
1826      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1827      *         true if supplied registrant address is not registered.
1828      */
1829     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1830 
1831     /**
1832      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1833      */
1834     function register(address registrant) external;
1835 
1836     /**
1837      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1838      */
1839     function registerAndSubscribe(address registrant, address subscription) external;
1840 
1841     /**
1842      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1843      *         address without subscribing.
1844      */
1845     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1846 
1847     /**
1848      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1849      *         Note that this does not remove any filtered addresses or codeHashes.
1850      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1851      */
1852     function unregister(address addr) external;
1853 
1854     /**
1855      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1856      */
1857     function updateOperator(address registrant, address operator, bool filtered) external;
1858 
1859     /**
1860      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1861      */
1862     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1863 
1864     /**
1865      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1866      */
1867     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1868 
1869     /**
1870      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1871      */
1872     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1873 
1874     /**
1875      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1876      *         subscription if present.
1877      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1878      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1879      *         used.
1880      */
1881     function subscribe(address registrant, address registrantToSubscribe) external;
1882 
1883     /**
1884      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1885      */
1886     function unsubscribe(address registrant, bool copyExistingEntries) external;
1887 
1888     /**
1889      * @notice Get the subscription address of a given registrant, if any.
1890      */
1891     function subscriptionOf(address addr) external returns (address registrant);
1892 
1893     /**
1894      * @notice Get the set of addresses subscribed to a given registrant.
1895      *         Note that order is not guaranteed as updates are made.
1896      */
1897     function subscribers(address registrant) external returns (address[] memory);
1898 
1899     /**
1900      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1901      *         Note that order is not guaranteed as updates are made.
1902      */
1903     function subscriberAt(address registrant, uint256 index) external returns (address);
1904 
1905     /**
1906      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1907      */
1908     function copyEntriesOf(address registrant, address registrantToCopy) external;
1909 
1910     /**
1911      * @notice Returns true if operator is filtered by a given address or its subscription.
1912      */
1913     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1914 
1915     /**
1916      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1917      */
1918     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1919 
1920     /**
1921      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1922      */
1923     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1924 
1925     /**
1926      * @notice Returns a list of filtered operators for a given address or its subscription.
1927      */
1928     function filteredOperators(address addr) external returns (address[] memory);
1929 
1930     /**
1931      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1932      *         Note that order is not guaranteed as updates are made.
1933      */
1934     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1935 
1936     /**
1937      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1938      *         its subscription.
1939      *         Note that order is not guaranteed as updates are made.
1940      */
1941     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1942 
1943     /**
1944      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1945      *         its subscription.
1946      *         Note that order is not guaranteed as updates are made.
1947      */
1948     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1949 
1950     /**
1951      * @notice Returns true if an address has registered
1952      */
1953     function isRegistered(address addr) external returns (bool);
1954 
1955     /**
1956      * @dev Convenience method to compute the code hash of an arbitrary contract
1957      */
1958     function codeHashOf(address addr) external returns (bytes32);
1959 }
1960 
1961 /**
1962  * @title  OperatorFilterer
1963  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1964  *         registrant's entries in the OperatorFilterRegistry.
1965  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1966  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1967  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1968  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1969  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1970  *         will be locked to the options set during construction.
1971  */
1972 
1973 abstract contract OperatorFilterer {
1974     /// @dev Emitted when an operator is not allowed.
1975     error OperatorNotAllowed(address operator);
1976 
1977     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1978         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1979 
1980     /// @dev The constructor that is called when the contract is being deployed.
1981     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1982         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1983         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1984         // order for the modifier to filter addresses.
1985         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1986             if (subscribe) {
1987                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1988             } else {
1989                 if (subscriptionOrRegistrantToCopy != address(0)) {
1990                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1991                 } else {
1992                     OPERATOR_FILTER_REGISTRY.register(address(this));
1993                 }
1994             }
1995         }
1996     }
1997 
1998     /**
1999      * @dev A helper function to check if an operator is allowed.
2000      */
2001     modifier onlyAllowedOperator(address from) virtual {
2002         // Allow spending tokens from addresses with balance
2003         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2004         // from an EOA.
2005         if (from != msg.sender) {
2006             _checkFilterOperator(msg.sender);
2007         }
2008         _;
2009     }
2010 
2011     /**
2012      * @dev A helper function to check if an operator approval is allowed.
2013      */
2014     modifier onlyAllowedOperatorApproval(address operator) virtual {
2015         _checkFilterOperator(operator);
2016         _;
2017     }
2018 
2019     /**
2020      * @dev A helper function to check if an operator is allowed.
2021      */
2022     function _checkFilterOperator(address operator) internal view virtual {
2023         // Check registry code length to facilitate testing in environments without a deployed registry.
2024         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2025             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
2026             // may specify their own OperatorFilterRegistry implementations, which may behave differently
2027             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2028                 revert OperatorNotAllowed(operator);
2029             }
2030         }
2031     }
2032 }
2033 
2034 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2035     /// @dev The constructor that is called when the contract is being deployed.
2036     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2037 }
2038 
2039 
2040 pragma solidity >=0.7.0 <0.9.0;
2041 
2042 /**
2043  * @author LD
2044  * @title NFT
2045  * @dev Deploy a ERC721A NFT Collection
2046  */
2047 contract JokerClub is ERC721A, Ownable, DefaultOperatorFilterer {
2048     using Counters for Counters.Counter;
2049     Counters.Counter private _tokenIds;
2050 
2051     mapping(address => uint256[]) private _ownedTokens;
2052 
2053     mapping(address => uint256) private _numTokenMinted;
2054 
2055     using Strings for uint256;
2056 
2057     // @dev Merkle root of the whitelist
2058     bytes32 public merkleRoot;
2059 
2060     // @dev Collcetion max supply 
2061     uint public maxSupply = 8888;
2062 
2063     // @dev Price token in ether
2064     uint256 public price = 0.08 ether;
2065 
2066     // @dev Reveal state of the collection
2067     bool public revealed;
2068 
2069     // @dev Is whitelist sales enabled
2070     bool public whitelistSale = true;
2071 
2072     // @dev Address of the team wallet
2073     address payable public _team;
2074 
2075     //@dev Pause state of the sale
2076     bool public paused = true;
2077 
2078     address payable public partner;
2079 
2080 
2081 
2082     function getOwnedTokens(address owner) public view returns (uint256[] memory) {
2083         return _ownedTokens[owner];
2084     }
2085 
2086 
2087     function getTokensMinted(address owner) public view returns (uint256) {
2088         return _numTokenMinted[owner];
2089     }
2090 
2091     /**
2092      * @dev See {IERC721-setApprovalForAll}.
2093      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2094      */
2095     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2096         super.setApprovalForAll(operator, approved);
2097     }
2098 
2099     /**
2100      * @dev See {IERC721-approve}.
2101      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2102      */
2103     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2104         super.approve(operator, tokenId);
2105     }
2106 
2107     function transferToken(address from, address to, uint256 tokenId) private {
2108         uint256[] storage fromTokens = _ownedTokens[from];
2109         for (uint256 i = 0; i < fromTokens.length; i++) {
2110             if (fromTokens[i] == tokenId) {
2111                 fromTokens[i] = fromTokens[fromTokens.length - 1];
2112                 fromTokens.pop();
2113                 break;
2114             }
2115         }
2116         _ownedTokens[to].push(tokenId);
2117     }
2118     
2119     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2120         super.transferFrom(from, to, tokenId);
2121         transferToken(from, to, tokenId);
2122     }
2123 
2124     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2125         super.safeTransferFrom(from, to, tokenId);
2126         transferToken(from, to, tokenId);
2127     }
2128     
2129     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
2130         super.safeTransferFrom(from, to, tokenId, data);
2131         transferToken(from, to, tokenId);
2132     }
2133 
2134     /**
2135      * @dev See {IERC165-supportsInterface}.
2136      */
2137     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A) returns (bool) {
2138         return super.supportsInterface(interfaceId);
2139     }
2140 
2141     function airdrop(address[][] memory recipients, uint256[] memory numNFTs) external onlyOwner {
2142         require(recipients.length == numNFTs.length, "Input arrays must have the same length");
2143         uint256 newTokenId;
2144 
2145         for (uint256 i = 0; i < recipients.length; i++) {
2146             for (uint256 j = 0; j < recipients[i].length; j++) {
2147                 address recipient = recipients[i][j];
2148                 uint256 count = numNFTs[i];
2149                 _mint(recipient, count);
2150                 _numTokenMinted[recipient] += count;
2151                 for (uint256 index = 0; index < count; index++) {
2152                     newTokenId = _tokenIds.current();
2153                     _ownedTokens[recipient].push(newTokenId);
2154                     _tokenIds.increment();
2155                 }
2156             }
2157         }
2158     }
2159 
2160     /**
2161      * @dev Collection URIs
2162      * baseURI : URI of the revealed NFT
2163      * hiddenURI : URI of the non revealed NFT
2164      */
2165     string public baseURI;
2166     string public hiddenURI;
2167 
2168     // @dev Max token by wallet
2169     uint public maxByWallet = 5;
2170 
2171 
2172     /**
2173      * @dev Modifier isWhitelisted to check if the caller is on the whitelist
2174      */
2175     modifier isWhitelisted(bytes32 [] calldata merkleProof, address recipient) {
2176         if (whitelistSale) {
2177             bytes32 leaf = keccak256(abi.encodePacked(recipient));
2178             require(MerkleProof.verify(merkleProof, merkleRoot, leaf), "Not whitelisted !");
2179         }
2180 
2181         _;
2182     }
2183 
2184 
2185     modifier onlyPartner() {
2186         require(msg.sender == partner, "Not authorized");
2187         _;
2188     }
2189 
2190 
2191     function setPartner(address payable _partner) public onlyPartner {
2192         partner = _partner;
2193     }
2194 
2195     constructor(address payable team, address payable _partner) ERC721A("JokerClub", "JKR") {
2196         _team = team;
2197         partner = _partner;
2198         _mint(team, 444);
2199     }
2200 
2201     function mint(uint256 quantity, bytes32[] calldata merkleProof, address recipient) external payable isWhitelisted(merkleProof, recipient) {
2202         // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
2203         require(!paused, "Sale is paused !");
2204         require (quantity + _numTokenMinted[recipient] <= maxByWallet, "Request too much for one wallet !");
2205         require (quantity + _totalMinted() <= maxSupply, "Max supply reached !");
2206         require(msg.value >= price * quantity, "Not enough ETH !");
2207 
2208         _mint(recipient, quantity);
2209         uint256 newTokenId;
2210         for (uint256 index = 0; index < quantity; index++) {
2211             newTokenId = _tokenIds.current();
2212             _ownedTokens[recipient].push(newTokenId);
2213             _tokenIds.increment();
2214         }
2215 
2216         _numTokenMinted[recipient] += quantity;
2217     }
2218 
2219     /**
2220      * @dev Change the pause state of whitelist and public sale
2221      */
2222     function setPaused(bool value) public onlyOwner {
2223         paused = value;
2224     }
2225 
2226     /**
2227      * @dev Change the `price` of the token for `newPrice`
2228      */
2229     function setPrice(uint256 newPrice) external onlyOwner {
2230         price = newPrice;
2231     }
2232 
2233     function setMaxByWallet(uint newValue) external onlyOwner {
2234         maxByWallet = newValue;
2235     }
2236 
2237     /**
2238      * @dev Update the merkle root
2239      *
2240      * @param newMerkleRoot must start with 0x  
2241      * 
2242      */
2243     function setMerkleRoot(bytes32 newMerkleRoot) external onlyOwner {
2244         merkleRoot = newMerkleRoot;
2245     }
2246 
2247     function setTeamAddress(address payable team) public onlyOwner {
2248         _team = team;
2249     }
2250 
2251     function setWhitelistSale(bool value) public onlyOwner {
2252         whitelistSale = value;
2253     }
2254     
2255     /**
2256      * @dev Withdraw funds to the `_team` wallet
2257      */
2258     function withdraw() external onlyPartner {
2259         require(address(this).balance != 0, "Nothing to withdraw");
2260         (bool success, ) = partner.call{value: address(this).balance }("");
2261            require(success, 'transfer failed');
2262     }
2263 
2264     /**
2265      * @dev Reveal the final URI
2266      */
2267     function setRevealCollection(bool value) public onlyOwner {
2268         revealed = value;
2269     }
2270 
2271     /**
2272      * @dev Reveal the final URI
2273      */
2274     function setBaseURI(string calldata value) public onlyOwner {
2275         baseURI = value;
2276     }
2277 
2278     /**
2279      * @dev Reveal the final URI
2280      */
2281     function setHiddenURI(string calldata value) public onlyOwner {
2282         hiddenURI = value;
2283     }
2284 
2285     function _baseURI() internal view virtual override returns (string memory) {
2286         return baseURI;
2287     }
2288 
2289     /**
2290      * @dev Return the URI of the NFT
2291      * @notice return the hidden URI then the Revealed JSON when the Revealed param is true
2292      */
2293     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2294         require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
2295         if (revealed == false) {
2296             return hiddenURI;
2297         }
2298 
2299         string memory URI = _baseURI();
2300         return bytes(URI).length > 0 ? string(abi.encodePacked(URI, tokenId.toString(), ".json")) : "";
2301     }
2302 }