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
216 // File: @openzeppelin/contracts/utils/Strings.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev String operations.
225  */
226 library Strings {
227     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
228     uint8 private constant _ADDRESS_LENGTH = 20;
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
232      */
233     function toString(uint256 value) internal pure returns (string memory) {
234         // Inspired by OraclizeAPI's implementation - MIT licence
235         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
236 
237         if (value == 0) {
238             return "0";
239         }
240         uint256 temp = value;
241         uint256 digits;
242         while (temp != 0) {
243             digits++;
244             temp /= 10;
245         }
246         bytes memory buffer = new bytes(digits);
247         while (value != 0) {
248             digits -= 1;
249             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
250             value /= 10;
251         }
252         return string(buffer);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
257      */
258     function toHexString(uint256 value) internal pure returns (string memory) {
259         if (value == 0) {
260             return "0x00";
261         }
262         uint256 temp = value;
263         uint256 length = 0;
264         while (temp != 0) {
265             length++;
266             temp >>= 8;
267         }
268         return toHexString(value, length);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
273      */
274     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
275         bytes memory buffer = new bytes(2 * length + 2);
276         buffer[0] = "0";
277         buffer[1] = "x";
278         for (uint256 i = 2 * length + 1; i > 1; --i) {
279             buffer[i] = _HEX_SYMBOLS[value & 0xf];
280             value >>= 4;
281         }
282         require(value == 0, "Strings: hex length insufficient");
283         return string(buffer);
284     }
285 
286     /**
287      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
288      */
289     function toHexString(address addr) internal pure returns (string memory) {
290         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/Context.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         return msg.data;
318     }
319 }
320 
321 // File: @openzeppelin/contracts/access/Ownable.sol
322 
323 
324 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 
329 /**
330  * @dev Contract module which provides a basic access control mechanism, where
331  * there is an account (an owner) that can be granted exclusive access to
332  * specific functions.
333  *
334  * By default, the owner account will be the one that deploys the contract. This
335  * can later be changed with {transferOwnership}.
336  *
337  * This module is used through inheritance. It will make available the modifier
338  * `onlyOwner`, which can be applied to your functions to restrict their use to
339  * the owner.
340  */
341 abstract contract Ownable is Context {
342     address private _owner;
343 
344     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
345 
346     /**
347      * @dev Initializes the contract setting the deployer as the initial owner.
348      */
349     constructor() {
350         _transferOwnership(_msgSender());
351     }
352 
353     /**
354      * @dev Throws if called by any account other than the owner.
355      */
356     modifier onlyOwner() {
357         _checkOwner();
358         _;
359     }
360 
361     /**
362      * @dev Returns the address of the current owner.
363      */
364     function owner() public view virtual returns (address) {
365         return _owner;
366     }
367 
368     /**
369      * @dev Throws if the sender is not the owner.
370      */
371     function _checkOwner() internal view virtual {
372         require(owner() == _msgSender(), "Ownable: caller is not the owner");
373     }
374 
375     /**
376      * @dev Leaves the contract without owner. It will not be possible to call
377      * `onlyOwner` functions anymore. Can only be called by the current owner.
378      *
379      * NOTE: Renouncing ownership will leave the contract without an owner,
380      * thereby removing any functionality that is only available to the owner.
381      */
382     function renounceOwnership() public virtual onlyOwner {
383         _transferOwnership(address(0));
384     }
385 
386     /**
387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
388      * Can only be called by the current owner.
389      */
390     function transferOwnership(address newOwner) public virtual onlyOwner {
391         require(newOwner != address(0), "Ownable: new owner is the zero address");
392         _transferOwnership(newOwner);
393     }
394 
395     /**
396      * @dev Transfers ownership of the contract to a new account (`newOwner`).
397      * Internal function without access restriction.
398      */
399     function _transferOwnership(address newOwner) internal virtual {
400         address oldOwner = _owner;
401         _owner = newOwner;
402         emit OwnershipTransferred(oldOwner, newOwner);
403     }
404 }
405 
406 // File: erc721a/contracts/IERC721A.sol
407 
408 
409 // ERC721A Contracts v4.2.3
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
429      * Cannot query the balance for the zero address.
430      */
431     error BalanceQueryForZeroAddress();
432 
433     /**
434      * Cannot mint to the zero address.
435      */
436     error MintToZeroAddress();
437 
438     /**
439      * The quantity of tokens minted must be more than zero.
440      */
441     error MintZeroQuantity();
442 
443     /**
444      * The token does not exist.
445      */
446     error OwnerQueryForNonexistentToken();
447 
448     /**
449      * The caller must own the token or be an approved operator.
450      */
451     error TransferCallerNotOwnerNorApproved();
452 
453     /**
454      * The token must be owned by `from`.
455      */
456     error TransferFromIncorrectOwner();
457 
458     /**
459      * Cannot safely transfer to a contract that does not implement the
460      * ERC721Receiver interface.
461      */
462     error TransferToNonERC721ReceiverImplementer();
463 
464     /**
465      * Cannot transfer to the zero address.
466      */
467     error TransferToZeroAddress();
468 
469     /**
470      * The token does not exist.
471      */
472     error URIQueryForNonexistentToken();
473 
474     /**
475      * The `quantity` minted with ERC2309 exceeds the safety limit.
476      */
477     error MintERC2309QuantityExceedsLimit();
478 
479     /**
480      * The `extraData` cannot be set on an unintialized ownership slot.
481      */
482     error OwnershipNotInitializedForExtraData();
483 
484     // =============================================================
485     //                            STRUCTS
486     // =============================================================
487 
488     struct TokenOwnership {
489         // The address of the owner.
490         address addr;
491         // Stores the start time of ownership with minimal overhead for tokenomics.
492         uint64 startTimestamp;
493         // Whether the token has been burned.
494         bool burned;
495         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
496         uint24 extraData;
497     }
498 
499     // =============================================================
500     //                         TOKEN COUNTERS
501     // =============================================================
502 
503     /**
504      * @dev Returns the total number of tokens in existence.
505      * Burned tokens will reduce the count.
506      * To get the total number of tokens minted, please see {_totalMinted}.
507      */
508     function totalSupply() external view returns (uint256);
509 
510     // =============================================================
511     //                            IERC165
512     // =============================================================
513 
514     /**
515      * @dev Returns true if this contract implements the interface defined by
516      * `interfaceId`. See the corresponding
517      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
518      * to learn more about how these ids are created.
519      *
520      * This function call must use less than 30000 gas.
521      */
522     function supportsInterface(bytes4 interfaceId) external view returns (bool);
523 
524     // =============================================================
525     //                            IERC721
526     // =============================================================
527 
528     /**
529      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
530      */
531     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
532 
533     /**
534      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
535      */
536     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
537 
538     /**
539      * @dev Emitted when `owner` enables or disables
540      * (`approved`) `operator` to manage all of its assets.
541      */
542     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
543 
544     /**
545      * @dev Returns the number of tokens in `owner`'s account.
546      */
547     function balanceOf(address owner) external view returns (uint256 balance);
548 
549     /**
550      * @dev Returns the owner of the `tokenId` token.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must exist.
555      */
556     function ownerOf(uint256 tokenId) external view returns (address owner);
557 
558     /**
559      * @dev Safely transfers `tokenId` token from `from` to `to`,
560      * checking first that contract recipients are aware of the ERC721 protocol
561      * to prevent tokens from being forever locked.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must exist and be owned by `from`.
568      * - If the caller is not `from`, it must be have been allowed to move
569      * this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement
571      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
572      *
573      * Emits a {Transfer} event.
574      */
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 tokenId,
579         bytes calldata data
580     ) external payable;
581 
582     /**
583      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId
589     ) external payable;
590 
591     /**
592      * @dev Transfers `tokenId` from `from` to `to`.
593      *
594      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
595      * whenever possible.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must be owned by `from`.
602      * - If the caller is not `from`, it must be approved to move this token
603      * by either {approve} or {setApprovalForAll}.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external payable;
612 
613     /**
614      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
615      * The approval is cleared when the token is transferred.
616      *
617      * Only a single account can be approved at a time, so approving the
618      * zero address clears previous approvals.
619      *
620      * Requirements:
621      *
622      * - The caller must own the token or be an approved operator.
623      * - `tokenId` must exist.
624      *
625      * Emits an {Approval} event.
626      */
627     function approve(address to, uint256 tokenId) external payable;
628 
629     /**
630      * @dev Approve or remove `operator` as an operator for the caller.
631      * Operators can call {transferFrom} or {safeTransferFrom}
632      * for any token owned by the caller.
633      *
634      * Requirements:
635      *
636      * - The `operator` cannot be the caller.
637      *
638      * Emits an {ApprovalForAll} event.
639      */
640     function setApprovalForAll(address operator, bool _approved) external;
641 
642     /**
643      * @dev Returns the account approved for `tokenId` token.
644      *
645      * Requirements:
646      *
647      * - `tokenId` must exist.
648      */
649     function getApproved(uint256 tokenId) external view returns (address operator);
650 
651     /**
652      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
653      *
654      * See {setApprovalForAll}.
655      */
656     function isApprovedForAll(address owner, address operator) external view returns (bool);
657 
658     // =============================================================
659     //                        IERC721Metadata
660     // =============================================================
661 
662     /**
663      * @dev Returns the token collection name.
664      */
665     function name() external view returns (string memory);
666 
667     /**
668      * @dev Returns the token collection symbol.
669      */
670     function symbol() external view returns (string memory);
671 
672     /**
673      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
674      */
675     function tokenURI(uint256 tokenId) external view returns (string memory);
676 
677     // =============================================================
678     //                           IERC2309
679     // =============================================================
680 
681     /**
682      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
683      * (inclusive) is transferred from `from` to `to`, as defined in the
684      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
685      *
686      * See {_mintERC2309} for more details.
687      */
688     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
689 }
690 
691 // File: erc721a/contracts/ERC721A.sol
692 
693 
694 // ERC721A Contracts v4.2.3
695 // Creator: Chiru Labs
696 
697 pragma solidity ^0.8.4;
698 
699 
700 /**
701  * @dev Interface of ERC721 token receiver.
702  */
703 interface ERC721A__IERC721Receiver {
704     function onERC721Received(
705         address operator,
706         address from,
707         uint256 tokenId,
708         bytes calldata data
709     ) external returns (bytes4);
710 }
711 
712 /**
713  * @title ERC721A
714  *
715  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
716  * Non-Fungible Token Standard, including the Metadata extension.
717  * Optimized for lower gas during batch mints.
718  *
719  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
720  * starting from `_startTokenId()`.
721  *
722  * Assumptions:
723  *
724  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
725  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
726  */
727 contract ERC721A is IERC721A {
728     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
729     struct TokenApprovalRef {
730         address value;
731     }
732 
733     // =============================================================
734     //                           CONSTANTS
735     // =============================================================
736 
737     // Mask of an entry in packed address data.
738     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
739 
740     // The bit position of `numberMinted` in packed address data.
741     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
742 
743     // The bit position of `numberBurned` in packed address data.
744     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
745 
746     // The bit position of `aux` in packed address data.
747     uint256 private constant _BITPOS_AUX = 192;
748 
749     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
750     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
751 
752     // The bit position of `startTimestamp` in packed ownership.
753     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
754 
755     // The bit mask of the `burned` bit in packed ownership.
756     uint256 private constant _BITMASK_BURNED = 1 << 224;
757 
758     // The bit position of the `nextInitialized` bit in packed ownership.
759     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
760 
761     // The bit mask of the `nextInitialized` bit in packed ownership.
762     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
763 
764     // The bit position of `extraData` in packed ownership.
765     uint256 private constant _BITPOS_EXTRA_DATA = 232;
766 
767     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
768     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
769 
770     // The mask of the lower 160 bits for addresses.
771     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
772 
773     // The maximum `quantity` that can be minted with {_mintERC2309}.
774     // This limit is to prevent overflows on the address data entries.
775     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
776     // is required to cause an overflow, which is unrealistic.
777     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
778 
779     // The `Transfer` event signature is given by:
780     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
781     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
782         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
783 
784     // =============================================================
785     //                            STORAGE
786     // =============================================================
787 
788     // The next token ID to be minted.
789     uint256 private _currentIndex;
790 
791     // The number of tokens burned.
792     uint256 private _burnCounter;
793 
794     // Token name
795     string private _name;
796 
797     // Token symbol
798     string private _symbol;
799 
800     // Mapping from token ID to ownership details
801     // An empty struct value does not necessarily mean the token is unowned.
802     // See {_packedOwnershipOf} implementation for details.
803     //
804     // Bits Layout:
805     // - [0..159]   `addr`
806     // - [160..223] `startTimestamp`
807     // - [224]      `burned`
808     // - [225]      `nextInitialized`
809     // - [232..255] `extraData`
810     mapping(uint256 => uint256) private _packedOwnerships;
811 
812     // Mapping owner address to address data.
813     //
814     // Bits Layout:
815     // - [0..63]    `balance`
816     // - [64..127]  `numberMinted`
817     // - [128..191] `numberBurned`
818     // - [192..255] `aux`
819     mapping(address => uint256) private _packedAddressData;
820 
821     // Mapping from token ID to approved address.
822     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
823 
824     // Mapping from owner to operator approvals
825     mapping(address => mapping(address => bool)) private _operatorApprovals;
826 
827     // =============================================================
828     //                          CONSTRUCTOR
829     // =============================================================
830 
831     constructor(string memory name_, string memory symbol_) {
832         _name = name_;
833         _symbol = symbol_;
834         _currentIndex = _startTokenId();
835     }
836 
837     // =============================================================
838     //                   TOKEN COUNTING OPERATIONS
839     // =============================================================
840 
841     /**
842      * @dev Returns the starting token ID.
843      * To change the starting token ID, please override this function.
844      */
845     function _startTokenId() internal view virtual returns (uint256) {
846         return 0;
847     }
848 
849     /**
850      * @dev Returns the next token ID to be minted.
851      */
852     function _nextTokenId() internal view virtual returns (uint256) {
853         return _currentIndex;
854     }
855 
856     /**
857      * @dev Returns the total number of tokens in existence.
858      * Burned tokens will reduce the count.
859      * To get the total number of tokens minted, please see {_totalMinted}.
860      */
861     function totalSupply() public view virtual override returns (uint256) {
862         // Counter underflow is impossible as _burnCounter cannot be incremented
863         // more than `_currentIndex - _startTokenId()` times.
864         unchecked {
865             return _currentIndex - _burnCounter - _startTokenId();
866         }
867     }
868 
869     /**
870      * @dev Returns the total amount of tokens minted in the contract.
871      */
872     function _totalMinted() internal view virtual returns (uint256) {
873         // Counter underflow is impossible as `_currentIndex` does not decrement,
874         // and it is initialized to `_startTokenId()`.
875         unchecked {
876             return _currentIndex - _startTokenId();
877         }
878     }
879 
880     /**
881      * @dev Returns the total number of tokens burned.
882      */
883     function _totalBurned() internal view virtual returns (uint256) {
884         return _burnCounter;
885     }
886 
887     // =============================================================
888     //                    ADDRESS DATA OPERATIONS
889     // =============================================================
890 
891     /**
892      * @dev Returns the number of tokens in `owner`'s account.
893      */
894     function balanceOf(address owner) public view virtual override returns (uint256) {
895         if (owner == address(0)) revert BalanceQueryForZeroAddress();
896         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
897     }
898 
899     /**
900      * Returns the number of tokens minted by `owner`.
901      */
902     function _numberMinted(address owner) internal view returns (uint256) {
903         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
904     }
905 
906     /**
907      * Returns the number of tokens burned by or on behalf of `owner`.
908      */
909     function _numberBurned(address owner) internal view returns (uint256) {
910         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
911     }
912 
913     /**
914      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
915      */
916     function _getAux(address owner) internal view returns (uint64) {
917         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
918     }
919 
920     /**
921      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
922      * If there are multiple variables, please pack them into a uint64.
923      */
924     function _setAux(address owner, uint64 aux) internal virtual {
925         uint256 packed = _packedAddressData[owner];
926         uint256 auxCasted;
927         // Cast `aux` with assembly to avoid redundant masking.
928         assembly {
929             auxCasted := aux
930         }
931         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
932         _packedAddressData[owner] = packed;
933     }
934 
935     // =============================================================
936     //                            IERC165
937     // =============================================================
938 
939     /**
940      * @dev Returns true if this contract implements the interface defined by
941      * `interfaceId`. See the corresponding
942      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
943      * to learn more about how these ids are created.
944      *
945      * This function call must use less than 30000 gas.
946      */
947     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
948         // The interface IDs are constants representing the first 4 bytes
949         // of the XOR of all function selectors in the interface.
950         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
951         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
952         return
953             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
954             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
955             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
956     }
957 
958     // =============================================================
959     //                        IERC721Metadata
960     // =============================================================
961 
962     /**
963      * @dev Returns the token collection name.
964      */
965     function name() public view virtual override returns (string memory) {
966         return _name;
967     }
968 
969     /**
970      * @dev Returns the token collection symbol.
971      */
972     function symbol() public view virtual override returns (string memory) {
973         return _symbol;
974     }
975 
976     /**
977      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
978      */
979     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
980         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
981 
982         string memory baseURI = _baseURI();
983         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
984     }
985 
986     /**
987      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
988      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
989      * by default, it can be overridden in child contracts.
990      */
991     function _baseURI() internal view virtual returns (string memory) {
992         return '';
993     }
994 
995     // =============================================================
996     //                     OWNERSHIPS OPERATIONS
997     // =============================================================
998 
999     /**
1000      * @dev Returns the owner of the `tokenId` token.
1001      *
1002      * Requirements:
1003      *
1004      * - `tokenId` must exist.
1005      */
1006     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1007         return address(uint160(_packedOwnershipOf(tokenId)));
1008     }
1009 
1010     /**
1011      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1012      * It gradually moves to O(1) as tokens get transferred around over time.
1013      */
1014     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1015         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1016     }
1017 
1018     /**
1019      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1020      */
1021     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1022         return _unpackedOwnership(_packedOwnerships[index]);
1023     }
1024 
1025     /**
1026      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1027      */
1028     function _initializeOwnershipAt(uint256 index) internal virtual {
1029         if (_packedOwnerships[index] == 0) {
1030             _packedOwnerships[index] = _packedOwnershipOf(index);
1031         }
1032     }
1033 
1034     /**
1035      * Returns the packed ownership data of `tokenId`.
1036      */
1037     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1038         uint256 curr = tokenId;
1039 
1040         unchecked {
1041             if (_startTokenId() <= curr)
1042                 if (curr < _currentIndex) {
1043                     uint256 packed = _packedOwnerships[curr];
1044                     // If not burned.
1045                     if (packed & _BITMASK_BURNED == 0) {
1046                         // Invariant:
1047                         // There will always be an initialized ownership slot
1048                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1049                         // before an unintialized ownership slot
1050                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1051                         // Hence, `curr` will not underflow.
1052                         //
1053                         // We can directly compare the packed value.
1054                         // If the address is zero, packed will be zero.
1055                         while (packed == 0) {
1056                             packed = _packedOwnerships[--curr];
1057                         }
1058                         return packed;
1059                     }
1060                 }
1061         }
1062         revert OwnerQueryForNonexistentToken();
1063     }
1064 
1065     /**
1066      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1067      */
1068     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1069         ownership.addr = address(uint160(packed));
1070         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1071         ownership.burned = packed & _BITMASK_BURNED != 0;
1072         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1073     }
1074 
1075     /**
1076      * @dev Packs ownership data into a single uint256.
1077      */
1078     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1079         assembly {
1080             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1081             owner := and(owner, _BITMASK_ADDRESS)
1082             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1083             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1084         }
1085     }
1086 
1087     /**
1088      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1089      */
1090     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1091         // For branchless setting of the `nextInitialized` flag.
1092         assembly {
1093             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1094             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1095         }
1096     }
1097 
1098     // =============================================================
1099     //                      APPROVAL OPERATIONS
1100     // =============================================================
1101 
1102     /**
1103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1104      * The approval is cleared when the token is transferred.
1105      *
1106      * Only a single account can be approved at a time, so approving the
1107      * zero address clears previous approvals.
1108      *
1109      * Requirements:
1110      *
1111      * - The caller must own the token or be an approved operator.
1112      * - `tokenId` must exist.
1113      *
1114      * Emits an {Approval} event.
1115      */
1116     function approve(address to, uint256 tokenId) public payable virtual override {
1117         address owner = ownerOf(tokenId);
1118 
1119         if (_msgSenderERC721A() != owner)
1120             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1121                 revert ApprovalCallerNotOwnerNorApproved();
1122             }
1123 
1124         _tokenApprovals[tokenId].value = to;
1125         emit Approval(owner, to, tokenId);
1126     }
1127 
1128     /**
1129      * @dev Returns the account approved for `tokenId` token.
1130      *
1131      * Requirements:
1132      *
1133      * - `tokenId` must exist.
1134      */
1135     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1136         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1137 
1138         return _tokenApprovals[tokenId].value;
1139     }
1140 
1141     /**
1142      * @dev Approve or remove `operator` as an operator for the caller.
1143      * Operators can call {transferFrom} or {safeTransferFrom}
1144      * for any token owned by the caller.
1145      *
1146      * Requirements:
1147      *
1148      * - The `operator` cannot be the caller.
1149      *
1150      * Emits an {ApprovalForAll} event.
1151      */
1152     function setApprovalForAll(address operator, bool approved) public virtual override {
1153         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1154         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1155     }
1156 
1157     /**
1158      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1159      *
1160      * See {setApprovalForAll}.
1161      */
1162     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1163         return _operatorApprovals[owner][operator];
1164     }
1165 
1166     /**
1167      * @dev Returns whether `tokenId` exists.
1168      *
1169      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1170      *
1171      * Tokens start existing when they are minted. See {_mint}.
1172      */
1173     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1174         return
1175             _startTokenId() <= tokenId &&
1176             tokenId < _currentIndex && // If within bounds,
1177             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1178     }
1179 
1180     /**
1181      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1182      */
1183     function _isSenderApprovedOrOwner(
1184         address approvedAddress,
1185         address owner,
1186         address msgSender
1187     ) private pure returns (bool result) {
1188         assembly {
1189             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1190             owner := and(owner, _BITMASK_ADDRESS)
1191             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1192             msgSender := and(msgSender, _BITMASK_ADDRESS)
1193             // `msgSender == owner || msgSender == approvedAddress`.
1194             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1195         }
1196     }
1197 
1198     /**
1199      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1200      */
1201     function _getApprovedSlotAndAddress(uint256 tokenId)
1202         private
1203         view
1204         returns (uint256 approvedAddressSlot, address approvedAddress)
1205     {
1206         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1207         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1208         assembly {
1209             approvedAddressSlot := tokenApproval.slot
1210             approvedAddress := sload(approvedAddressSlot)
1211         }
1212     }
1213 
1214     // =============================================================
1215     //                      TRANSFER OPERATIONS
1216     // =============================================================
1217 
1218     /**
1219      * @dev Transfers `tokenId` from `from` to `to`.
1220      *
1221      * Requirements:
1222      *
1223      * - `from` cannot be the zero address.
1224      * - `to` cannot be the zero address.
1225      * - `tokenId` token must be owned by `from`.
1226      * - If the caller is not `from`, it must be approved to move this token
1227      * by either {approve} or {setApprovalForAll}.
1228      *
1229      * Emits a {Transfer} event.
1230      */
1231     function transferFrom(
1232         address from,
1233         address to,
1234         uint256 tokenId
1235     ) public payable virtual override {
1236         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1237 
1238         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1239 
1240         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1241 
1242         // The nested ifs save around 20+ gas over a compound boolean condition.
1243         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1244             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1245 
1246         if (to == address(0)) revert TransferToZeroAddress();
1247 
1248         _beforeTokenTransfers(from, to, tokenId, 1);
1249 
1250         // Clear approvals from the previous owner.
1251         assembly {
1252             if approvedAddress {
1253                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1254                 sstore(approvedAddressSlot, 0)
1255             }
1256         }
1257 
1258         // Underflow of the sender's balance is impossible because we check for
1259         // ownership above and the recipient's balance can't realistically overflow.
1260         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1261         unchecked {
1262             // We can directly increment and decrement the balances.
1263             --_packedAddressData[from]; // Updates: `balance -= 1`.
1264             ++_packedAddressData[to]; // Updates: `balance += 1`.
1265 
1266             // Updates:
1267             // - `address` to the next owner.
1268             // - `startTimestamp` to the timestamp of transfering.
1269             // - `burned` to `false`.
1270             // - `nextInitialized` to `true`.
1271             _packedOwnerships[tokenId] = _packOwnershipData(
1272                 to,
1273                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1274             );
1275 
1276             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1277             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1278                 uint256 nextTokenId = tokenId + 1;
1279                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1280                 if (_packedOwnerships[nextTokenId] == 0) {
1281                     // If the next slot is within bounds.
1282                     if (nextTokenId != _currentIndex) {
1283                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1284                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1285                     }
1286                 }
1287             }
1288         }
1289 
1290         emit Transfer(from, to, tokenId);
1291         _afterTokenTransfers(from, to, tokenId, 1);
1292     }
1293 
1294     /**
1295      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1296      */
1297     function safeTransferFrom(
1298         address from,
1299         address to,
1300         uint256 tokenId
1301     ) public payable virtual override {
1302         safeTransferFrom(from, to, tokenId, '');
1303     }
1304 
1305     /**
1306      * @dev Safely transfers `tokenId` token from `from` to `to`.
1307      *
1308      * Requirements:
1309      *
1310      * - `from` cannot be the zero address.
1311      * - `to` cannot be the zero address.
1312      * - `tokenId` token must exist and be owned by `from`.
1313      * - If the caller is not `from`, it must be approved to move this token
1314      * by either {approve} or {setApprovalForAll}.
1315      * - If `to` refers to a smart contract, it must implement
1316      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1317      *
1318      * Emits a {Transfer} event.
1319      */
1320     function safeTransferFrom(
1321         address from,
1322         address to,
1323         uint256 tokenId,
1324         bytes memory _data
1325     ) public payable virtual override {
1326         transferFrom(from, to, tokenId);
1327         if (to.code.length != 0)
1328             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1329                 revert TransferToNonERC721ReceiverImplementer();
1330             }
1331     }
1332 
1333     /**
1334      * @dev Hook that is called before a set of serially-ordered token IDs
1335      * are about to be transferred. This includes minting.
1336      * And also called before burning one token.
1337      *
1338      * `startTokenId` - the first token ID to be transferred.
1339      * `quantity` - the amount to be transferred.
1340      *
1341      * Calling conditions:
1342      *
1343      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1344      * transferred to `to`.
1345      * - When `from` is zero, `tokenId` will be minted for `to`.
1346      * - When `to` is zero, `tokenId` will be burned by `from`.
1347      * - `from` and `to` are never both zero.
1348      */
1349     function _beforeTokenTransfers(
1350         address from,
1351         address to,
1352         uint256 startTokenId,
1353         uint256 quantity
1354     ) internal virtual {}
1355 
1356     /**
1357      * @dev Hook that is called after a set of serially-ordered token IDs
1358      * have been transferred. This includes minting.
1359      * And also called after one token has been burned.
1360      *
1361      * `startTokenId` - the first token ID to be transferred.
1362      * `quantity` - the amount to be transferred.
1363      *
1364      * Calling conditions:
1365      *
1366      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1367      * transferred to `to`.
1368      * - When `from` is zero, `tokenId` has been minted for `to`.
1369      * - When `to` is zero, `tokenId` has been burned by `from`.
1370      * - `from` and `to` are never both zero.
1371      */
1372     function _afterTokenTransfers(
1373         address from,
1374         address to,
1375         uint256 startTokenId,
1376         uint256 quantity
1377     ) internal virtual {}
1378 
1379     /**
1380      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1381      *
1382      * `from` - Previous owner of the given token ID.
1383      * `to` - Target address that will receive the token.
1384      * `tokenId` - Token ID to be transferred.
1385      * `_data` - Optional data to send along with the call.
1386      *
1387      * Returns whether the call correctly returned the expected magic value.
1388      */
1389     function _checkContractOnERC721Received(
1390         address from,
1391         address to,
1392         uint256 tokenId,
1393         bytes memory _data
1394     ) private returns (bool) {
1395         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1396             bytes4 retval
1397         ) {
1398             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1399         } catch (bytes memory reason) {
1400             if (reason.length == 0) {
1401                 revert TransferToNonERC721ReceiverImplementer();
1402             } else {
1403                 assembly {
1404                     revert(add(32, reason), mload(reason))
1405                 }
1406             }
1407         }
1408     }
1409 
1410     // =============================================================
1411     //                        MINT OPERATIONS
1412     // =============================================================
1413 
1414     /**
1415      * @dev Mints `quantity` tokens and transfers them to `to`.
1416      *
1417      * Requirements:
1418      *
1419      * - `to` cannot be the zero address.
1420      * - `quantity` must be greater than 0.
1421      *
1422      * Emits a {Transfer} event for each mint.
1423      */
1424     function _mint(address to, uint256 quantity) internal virtual {
1425         uint256 startTokenId = _currentIndex;
1426         if (quantity == 0) revert MintZeroQuantity();
1427 
1428         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1429 
1430         // Overflows are incredibly unrealistic.
1431         // `balance` and `numberMinted` have a maximum limit of 2**64.
1432         // `tokenId` has a maximum limit of 2**256.
1433         unchecked {
1434             // Updates:
1435             // - `balance += quantity`.
1436             // - `numberMinted += quantity`.
1437             //
1438             // We can directly add to the `balance` and `numberMinted`.
1439             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1440 
1441             // Updates:
1442             // - `address` to the owner.
1443             // - `startTimestamp` to the timestamp of minting.
1444             // - `burned` to `false`.
1445             // - `nextInitialized` to `quantity == 1`.
1446             _packedOwnerships[startTokenId] = _packOwnershipData(
1447                 to,
1448                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1449             );
1450 
1451             uint256 toMasked;
1452             uint256 end = startTokenId + quantity;
1453 
1454             // Use assembly to loop and emit the `Transfer` event for gas savings.
1455             // The duplicated `log4` removes an extra check and reduces stack juggling.
1456             // The assembly, together with the surrounding Solidity code, have been
1457             // delicately arranged to nudge the compiler into producing optimized opcodes.
1458             assembly {
1459                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1460                 toMasked := and(to, _BITMASK_ADDRESS)
1461                 // Emit the `Transfer` event.
1462                 log4(
1463                     0, // Start of data (0, since no data).
1464                     0, // End of data (0, since no data).
1465                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1466                     0, // `address(0)`.
1467                     toMasked, // `to`.
1468                     startTokenId // `tokenId`.
1469                 )
1470 
1471                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1472                 // that overflows uint256 will make the loop run out of gas.
1473                 // The compiler will optimize the `iszero` away for performance.
1474                 for {
1475                     let tokenId := add(startTokenId, 1)
1476                 } iszero(eq(tokenId, end)) {
1477                     tokenId := add(tokenId, 1)
1478                 } {
1479                     // Emit the `Transfer` event. Similar to above.
1480                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1481                 }
1482             }
1483             if (toMasked == 0) revert MintToZeroAddress();
1484 
1485             _currentIndex = end;
1486         }
1487         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1488     }
1489 
1490     /**
1491      * @dev Mints `quantity` tokens and transfers them to `to`.
1492      *
1493      * This function is intended for efficient minting only during contract creation.
1494      *
1495      * It emits only one {ConsecutiveTransfer} as defined in
1496      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1497      * instead of a sequence of {Transfer} event(s).
1498      *
1499      * Calling this function outside of contract creation WILL make your contract
1500      * non-compliant with the ERC721 standard.
1501      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1502      * {ConsecutiveTransfer} event is only permissible during contract creation.
1503      *
1504      * Requirements:
1505      *
1506      * - `to` cannot be the zero address.
1507      * - `quantity` must be greater than 0.
1508      *
1509      * Emits a {ConsecutiveTransfer} event.
1510      */
1511     function _mintERC2309(address to, uint256 quantity) internal virtual {
1512         uint256 startTokenId = _currentIndex;
1513         if (to == address(0)) revert MintToZeroAddress();
1514         if (quantity == 0) revert MintZeroQuantity();
1515         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1516 
1517         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1518 
1519         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1520         unchecked {
1521             // Updates:
1522             // - `balance += quantity`.
1523             // - `numberMinted += quantity`.
1524             //
1525             // We can directly add to the `balance` and `numberMinted`.
1526             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1527 
1528             // Updates:
1529             // - `address` to the owner.
1530             // - `startTimestamp` to the timestamp of minting.
1531             // - `burned` to `false`.
1532             // - `nextInitialized` to `quantity == 1`.
1533             _packedOwnerships[startTokenId] = _packOwnershipData(
1534                 to,
1535                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1536             );
1537 
1538             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1539 
1540             _currentIndex = startTokenId + quantity;
1541         }
1542         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1543     }
1544 
1545     /**
1546      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1547      *
1548      * Requirements:
1549      *
1550      * - If `to` refers to a smart contract, it must implement
1551      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1552      * - `quantity` must be greater than 0.
1553      *
1554      * See {_mint}.
1555      *
1556      * Emits a {Transfer} event for each mint.
1557      */
1558     function _safeMint(
1559         address to,
1560         uint256 quantity,
1561         bytes memory _data
1562     ) internal virtual {
1563         _mint(to, quantity);
1564 
1565         unchecked {
1566             if (to.code.length != 0) {
1567                 uint256 end = _currentIndex;
1568                 uint256 index = end - quantity;
1569                 do {
1570                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1571                         revert TransferToNonERC721ReceiverImplementer();
1572                     }
1573                 } while (index < end);
1574                 // Reentrancy protection.
1575                 if (_currentIndex != end) revert();
1576             }
1577         }
1578     }
1579 
1580     /**
1581      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1582      */
1583     function _safeMint(address to, uint256 quantity) internal virtual {
1584         _safeMint(to, quantity, '');
1585     }
1586 
1587     // =============================================================
1588     //                        BURN OPERATIONS
1589     // =============================================================
1590 
1591     /**
1592      * @dev Equivalent to `_burn(tokenId, false)`.
1593      */
1594     function _burn(uint256 tokenId) internal virtual {
1595         _burn(tokenId, false);
1596     }
1597 
1598     /**
1599      * @dev Destroys `tokenId`.
1600      * The approval is cleared when the token is burned.
1601      *
1602      * Requirements:
1603      *
1604      * - `tokenId` must exist.
1605      *
1606      * Emits a {Transfer} event.
1607      */
1608     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1609         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1610 
1611         address from = address(uint160(prevOwnershipPacked));
1612 
1613         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1614 
1615         if (approvalCheck) {
1616             // The nested ifs save around 20+ gas over a compound boolean condition.
1617             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1618                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1619         }
1620 
1621         _beforeTokenTransfers(from, address(0), tokenId, 1);
1622 
1623         // Clear approvals from the previous owner.
1624         assembly {
1625             if approvedAddress {
1626                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1627                 sstore(approvedAddressSlot, 0)
1628             }
1629         }
1630 
1631         // Underflow of the sender's balance is impossible because we check for
1632         // ownership above and the recipient's balance can't realistically overflow.
1633         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1634         unchecked {
1635             // Updates:
1636             // - `balance -= 1`.
1637             // - `numberBurned += 1`.
1638             //
1639             // We can directly decrement the balance, and increment the number burned.
1640             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1641             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1642 
1643             // Updates:
1644             // - `address` to the last owner.
1645             // - `startTimestamp` to the timestamp of burning.
1646             // - `burned` to `true`.
1647             // - `nextInitialized` to `true`.
1648             _packedOwnerships[tokenId] = _packOwnershipData(
1649                 from,
1650                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1651             );
1652 
1653             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1654             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1655                 uint256 nextTokenId = tokenId + 1;
1656                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1657                 if (_packedOwnerships[nextTokenId] == 0) {
1658                     // If the next slot is within bounds.
1659                     if (nextTokenId != _currentIndex) {
1660                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1661                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1662                     }
1663                 }
1664             }
1665         }
1666 
1667         emit Transfer(from, address(0), tokenId);
1668         _afterTokenTransfers(from, address(0), tokenId, 1);
1669 
1670         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1671         unchecked {
1672             _burnCounter++;
1673         }
1674     }
1675 
1676     // =============================================================
1677     //                     EXTRA DATA OPERATIONS
1678     // =============================================================
1679 
1680     /**
1681      * @dev Directly sets the extra data for the ownership data `index`.
1682      */
1683     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1684         uint256 packed = _packedOwnerships[index];
1685         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1686         uint256 extraDataCasted;
1687         // Cast `extraData` with assembly to avoid redundant masking.
1688         assembly {
1689             extraDataCasted := extraData
1690         }
1691         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1692         _packedOwnerships[index] = packed;
1693     }
1694 
1695     /**
1696      * @dev Called during each token transfer to set the 24bit `extraData` field.
1697      * Intended to be overridden by the cosumer contract.
1698      *
1699      * `previousExtraData` - the value of `extraData` before transfer.
1700      *
1701      * Calling conditions:
1702      *
1703      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1704      * transferred to `to`.
1705      * - When `from` is zero, `tokenId` will be minted for `to`.
1706      * - When `to` is zero, `tokenId` will be burned by `from`.
1707      * - `from` and `to` are never both zero.
1708      */
1709     function _extraData(
1710         address from,
1711         address to,
1712         uint24 previousExtraData
1713     ) internal view virtual returns (uint24) {}
1714 
1715     /**
1716      * @dev Returns the next extra data for the packed ownership data.
1717      * The returned result is shifted into position.
1718      */
1719     function _nextExtraData(
1720         address from,
1721         address to,
1722         uint256 prevOwnershipPacked
1723     ) private view returns (uint256) {
1724         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1725         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1726     }
1727 
1728     // =============================================================
1729     //                       OTHER OPERATIONS
1730     // =============================================================
1731 
1732     /**
1733      * @dev Returns the message sender (defaults to `msg.sender`).
1734      *
1735      * If you are writing GSN compatible contracts, you need to override this function.
1736      */
1737     function _msgSenderERC721A() internal view virtual returns (address) {
1738         return msg.sender;
1739     }
1740 
1741     /**
1742      * @dev Converts a uint256 to its ASCII string decimal representation.
1743      */
1744     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1745         assembly {
1746             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1747             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1748             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1749             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1750             let m := add(mload(0x40), 0xa0)
1751             // Update the free memory pointer to allocate.
1752             mstore(0x40, m)
1753             // Assign the `str` to the end.
1754             str := sub(m, 0x20)
1755             // Zeroize the slot after the string.
1756             mstore(str, 0)
1757 
1758             // Cache the end of the memory to calculate the length later.
1759             let end := str
1760 
1761             // We write the string from rightmost digit to leftmost digit.
1762             // The following is essentially a do-while loop that also handles the zero case.
1763             // prettier-ignore
1764             for { let temp := value } 1 {} {
1765                 str := sub(str, 1)
1766                 // Write the character to the pointer.
1767                 // The ASCII index of the '0' character is 48.
1768                 mstore8(str, add(48, mod(temp, 10)))
1769                 // Keep dividing `temp` until zero.
1770                 temp := div(temp, 10)
1771                 // prettier-ignore
1772                 if iszero(temp) { break }
1773             }
1774 
1775             let length := sub(end, str)
1776             // Move the pointer 32 bytes leftwards to make room for the length.
1777             str := sub(str, 0x20)
1778             // Store the length.
1779             mstore(str, length)
1780         }
1781     }
1782 }
1783 
1784 // File: contracts/1_Storage.sol
1785 
1786 
1787 
1788 pragma solidity ^0.8.14;
1789 
1790 
1791 
1792 
1793 
1794 
1795 contract GatesOfOxyaLand is ERC721A, Ownable  {
1796 
1797     using Strings for uint;
1798 
1799     event Staked(address owner, uint tokenId, uint timeframe);
1800     event Unstaked(address owner, uint tokenId, uint timeframe);
1801 
1802     // Is approving allowed for listing
1803     bool approvingAllowed;
1804 
1805     // Is staked
1806     mapping(uint => bool) public isStaked;
1807 
1808     // Max supply of the collection
1809     uint public constant MAX_SUPPLY = 13932 ;
1810 
1811     // Address of the sales contract
1812     address saleContract;
1813 
1814     // Address of the staking contract
1815     address public stakingContract;
1816 
1817     string public baseURI;
1818     bool private isRevealed = false;
1819 
1820     // Timestamp until contract is frozen
1821     uint public frozenTimestamp;
1822 
1823     // Provenance hash
1824     string public provenanceHash;
1825 
1826     constructor(string memory _baseURI) ERC721A("Gates Of Oxya - Lands", "GoOL") {
1827         baseURI = _baseURI;
1828     }
1829 
1830     modifier isStakingContract {
1831         require(msg.sender == stakingContract,"Not staking contract");
1832         _;
1833     }
1834 
1835     modifier isSaleContract {
1836         require(msg.sender == saleContract);
1837         _;
1838     }
1839 
1840     function setStakingContractAddress(address stakingContractAddress) external onlyOwner {
1841         stakingContract = stakingContractAddress;
1842     }   
1843 
1844     function setSaleContractAddress(address saleContractAddress) external onlyOwner {
1845         saleContract = saleContractAddress;
1846     }   
1847 
1848     function setApprovingAllowed() external onlyOwner {
1849         approvingAllowed = !approvingAllowed;
1850     }
1851 
1852     function setProvenanceHash(string memory _provenanceHash) public onlyOwner {
1853         provenanceHash = _provenanceHash;
1854     }
1855 
1856     function setBaseUri(string memory _baseURI) external onlyOwner {
1857         baseURI = _baseURI;
1858     }
1859 
1860     function setRevealCollection() external onlyOwner {
1861         isRevealed = true;
1862     }
1863 
1864     function mintBySaleContract(address _addressBuyer, uint _quantity) external isSaleContract {
1865         require(totalSupply()+_quantity <= MAX_SUPPLY, "Cannot mint over MAX_SUPPLY");
1866         _safeMint(_addressBuyer, _quantity);
1867     }
1868 
1869     /*
1870      * Staking function by Sale contract
1871      * function that stakes NFT and attributes lottery chances
1872      */
1873     function stakeNFT(uint tokenId) external isStakingContract {
1874         isStaked[tokenId] = true;
1875         emit Staked(msg.sender, tokenId, block.timestamp);
1876     }
1877     
1878     /*
1879      * Staking function by Owner
1880      * function that stakes NFT
1881      */
1882     function stakeByNFTOwner(uint[] memory tokenId) external {
1883         for(uint i = 0; i < tokenId.length; i++) {
1884             require(msg.sender == ownerOf(tokenId[i]), "TokenId not owned");
1885             require( isStaked[tokenId[i]] != true, "TokenId already staked!");
1886             isStaked[tokenId[i]] = true;
1887             emit Staked(msg.sender, tokenId[i], block.timestamp);
1888         }
1889     }
1890 
1891     /*
1892      * Unstaking function by Sale contract
1893      * function that unstakes NFT 
1894      */
1895     function unstakeNFT(uint[] memory tokenId, address _to) external isStakingContract {
1896         for(uint i = 0; i < tokenId.length; i++) {
1897             require(_to == ownerOf(tokenId[i]), "TokenId not owned");
1898             require( isStaked[tokenId[i]] != false, "TokenId not staked!");
1899             isStaked[tokenId[i]] = false;
1900             emit Unstaked(_to, tokenId[i], block.timestamp);
1901         }
1902     }
1903 
1904     /*
1905      * Frozen timestamp function
1906      * blocks transfers for a period of time
1907      */
1908     function setFrozen(uint timestamp) external onlyOwner {
1909         frozenTimestamp = timestamp;
1910     }
1911 
1912     /*
1913      * Block setApproval function
1914      * to allow or not approval, so the NFT can't be listed on OpenSea
1915      */
1916      function setApprovalForAll(address operator, bool approved) public override { 
1917         require(approvingAllowed, "Listing is not allowed");
1918         super.setApprovalForAll(operator, approved);
1919     }
1920     
1921     /*
1922      * Block appove function
1923      * to allow or not approval, so the NFT can't be listed on OpenSea
1924      */
1925      function approve(address to, uint tokenId) public payable override { 
1926         require(approvingAllowed, "Listing is not allowed");
1927         super.approve(to, tokenId);
1928     }
1929     
1930     /*
1931      * Before Token Transfer
1932      * Set the NFT not available for transfer if it's staked or frozen
1933      */
1934     function _beforeTokenTransfers(address from,
1935         address to,
1936         uint startTokenId,
1937         uint quantity) internal override { 
1938         super._beforeTokenTransfers(from, to, startTokenId, quantity);
1939 
1940         require(address(0) == from || block.timestamp >= frozenTimestamp, "frozen");
1941         require(isStaked[startTokenId] == false, "your NFT is not available for transfer");
1942     }
1943 
1944     /*
1945      * TokenURI
1946      * tokenURI is the link to the metadatas
1947      */
1948     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1949         require(_exists(_tokenId), "URI query for nonexistent token");
1950         if(isRevealed == true) {
1951             return string(abi.encodePacked(baseURI, _tokenId.toString()));
1952         }
1953         else {
1954             return string(abi.encodePacked(baseURI));
1955         }
1956     }
1957 }