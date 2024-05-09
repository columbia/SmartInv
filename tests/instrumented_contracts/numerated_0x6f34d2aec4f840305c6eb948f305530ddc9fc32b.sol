1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 /**
6  * @dev These functions deal with verification of Merkle Tree proofs.
7  *
8  * The tree and the proofs can be generated using our
9  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
10  * You will find a quickstart guide in the readme.
11  *
12  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
13  * hashing, or use a hash function other than keccak256 for hashing leaves.
14  * This is because the concatenation of a sorted pair of internal nodes in
15  * the merkle tree could be reinterpreted as a leaf value.
16  * OpenZeppelin's JavaScript library generates merkle trees that are safe
17  * against this attack out of the box.
18  */
19 library MerkleProof {
20     /**
21      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22      * defined by `root`. For this, a `proof` must be provided, containing
23      * sibling hashes on the branch from the leaf to the root of the tree. Each
24      * pair of leaves and each pair of pre-images are assumed to be sorted.
25      */
26     function verify(
27         bytes32[] memory proof,
28         bytes32 root,
29         bytes32 leaf
30     ) internal pure returns (bool) {
31         return processProof(proof, leaf) == root;
32     }
33 
34     /**
35      * @dev Calldata version of {verify}
36      *
37      * _Available since v4.7._
38      */
39     function verifyCalldata(
40         bytes32[] calldata proof,
41         bytes32 root,
42         bytes32 leaf
43     ) internal pure returns (bool) {
44         return processProofCalldata(proof, leaf) == root;
45     }
46 
47     /**
48      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
49      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
50      * hash matches the root of the tree. When processing the proof, the pairs
51      * of leafs & pre-images are assumed to be sorted.
52      *
53      * _Available since v4.4._
54      */
55     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
56         bytes32 computedHash = leaf;
57         for (uint256 i = 0; i < proof.length; i++) {
58             computedHash = _hashPair(computedHash, proof[i]);
59         }
60         return computedHash;
61     }
62 
63     /**
64      * @dev Calldata version of {processProof}
65      *
66      * _Available since v4.7._
67      */
68     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
69         bytes32 computedHash = leaf;
70         for (uint256 i = 0; i < proof.length; i++) {
71             computedHash = _hashPair(computedHash, proof[i]);
72         }
73         return computedHash;
74     }
75 
76     /**
77      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
78      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
79      *
80      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
81      *
82      * _Available since v4.7._
83      */
84     function multiProofVerify(
85         bytes32[] memory proof,
86         bool[] memory proofFlags,
87         bytes32 root,
88         bytes32[] memory leaves
89     ) internal pure returns (bool) {
90         return processMultiProof(proof, proofFlags, leaves) == root;
91     }
92 
93     /**
94      * @dev Calldata version of {multiProofVerify}
95      *
96      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
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
110      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
111      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
112      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
113      * respectively.
114      *
115      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
116      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
117      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
118      *
119      * _Available since v4.7._
120      */
121     function processMultiProof(
122         bytes32[] memory proof,
123         bool[] memory proofFlags,
124         bytes32[] memory leaves
125     ) internal pure returns (bytes32 merkleRoot) {
126         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
127         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
128         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
129         // the merkle tree.
130         uint256 leavesLen = leaves.length;
131         uint256 totalHashes = proofFlags.length;
132 
133         // Check proof validity.
134         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
135 
136         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
137         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
138         bytes32[] memory hashes = new bytes32[](totalHashes);
139         uint256 leafPos = 0;
140         uint256 hashPos = 0;
141         uint256 proofPos = 0;
142         // At each step, we compute the next hash using two values:
143         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
144         //   get the next hash.
145         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
146         //   `proof` array.
147         for (uint256 i = 0; i < totalHashes; i++) {
148             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
149             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
150             hashes[i] = _hashPair(a, b);
151         }
152 
153         if (totalHashes > 0) {
154             return hashes[totalHashes - 1];
155         } else if (leavesLen > 0) {
156             return leaves[0];
157         } else {
158             return proof[0];
159         }
160     }
161 
162     /**
163      * @dev Calldata version of {processMultiProof}.
164      *
165      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
166      *
167      * _Available since v4.7._
168      */
169     function processMultiProofCalldata(
170         bytes32[] calldata proof,
171         bool[] calldata proofFlags,
172         bytes32[] memory leaves
173     ) internal pure returns (bytes32 merkleRoot) {
174         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
175         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
176         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
177         // the merkle tree.
178         uint256 leavesLen = leaves.length;
179         uint256 totalHashes = proofFlags.length;
180 
181         // Check proof validity.
182         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
183 
184         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
185         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
186         bytes32[] memory hashes = new bytes32[](totalHashes);
187         uint256 leafPos = 0;
188         uint256 hashPos = 0;
189         uint256 proofPos = 0;
190         // At each step, we compute the next hash using two values:
191         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
192         //   get the next hash.
193         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
194         //   `proof` array.
195         for (uint256 i = 0; i < totalHashes; i++) {
196             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
197             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
198             hashes[i] = _hashPair(a, b);
199         }
200 
201         if (totalHashes > 0) {
202             return hashes[totalHashes - 1];
203         } else if (leavesLen > 0) {
204             return leaves[0];
205         } else {
206             return proof[0];
207         }
208     }
209 
210     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
211         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
212     }
213 
214     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
215         /// @solidity memory-safe-assembly
216         assembly {
217             mstore(0x00, a)
218             mstore(0x20, b)
219             value := keccak256(0x00, 0x40)
220         }
221     }
222 }
223 
224 
225 /**
226  * @dev Contract module that helps prevent reentrant calls to a function.
227  *
228  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
229  * available, which can be applied to functions to make sure there are no nested
230  * (reentrant) calls to them.
231  *
232  * Note that because there is a single `nonReentrant` guard, functions marked as
233  * `nonReentrant` may not call one another. This can be worked around by making
234  * those functions `private`, and then adding `external` `nonReentrant` entry
235  * points to them.
236  *
237  * TIP: If you would like to learn more about reentrancy and alternative ways
238  * to protect against it, check out our blog post
239  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
240  */
241 abstract contract ReentrancyGuard {
242     // Booleans are more expensive than uint256 or any type that takes up a full
243     // word because each write operation emits an extra SLOAD to first read the
244     // slot's contents, replace the bits taken up by the boolean, and then write
245     // back. This is the compiler's defense against contract upgrades and
246     // pointer aliasing, and it cannot be disabled.
247 
248     // The values being non-zero value makes deployment a bit more expensive,
249     // but in exchange the refund on every call to nonReentrant will be lower in
250     // amount. Since refunds are capped to a percentage of the total
251     // transaction's gas, it is best to keep them low in cases like this one, to
252     // increase the likelihood of the full refund coming into effect.
253     uint256 private constant _NOT_ENTERED = 1;
254     uint256 private constant _ENTERED = 2;
255 
256     uint256 private _status;
257 
258     constructor() {
259         _status = _NOT_ENTERED;
260     }
261 
262     /**
263      * @dev Prevents a contract from calling itself, directly or indirectly.
264      * Calling a `nonReentrant` function from another `nonReentrant`
265      * function is not supported. It is possible to prevent this from happening
266      * by making the `nonReentrant` function external, and making it call a
267      * `private` function that does the actual work.
268      */
269     modifier nonReentrant() {
270         _nonReentrantBefore();
271         _;
272         _nonReentrantAfter();
273     }
274 
275     function _nonReentrantBefore() private {
276         // On the first call to nonReentrant, _status will be _NOT_ENTERED
277         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
278 
279         // Any calls to nonReentrant after this point will fail
280         _status = _ENTERED;
281     }
282 
283     function _nonReentrantAfter() private {
284         // By storing the original value once again, a refund is triggered (see
285         // https://eips.ethereum.org/EIPS/eip-2200)
286         _status = _NOT_ENTERED;
287     }
288 }
289 
290 
291 /**
292  * @dev Provides information about the current execution context, including the
293  * sender of the transaction and its data. While these are generally available
294  * via msg.sender and msg.data, they should not be accessed in such a direct
295  * manner, since when dealing with meta-transactions the account sending and
296  * paying for execution may not be the actual sender (as far as an application
297  * is concerned).
298  *
299  * This contract is only required for intermediate, library-like contracts.
300  */
301 abstract contract Context {
302     function _msgSender() internal view virtual returns (address) {
303         return msg.sender;
304     }
305 
306     function _msgData() internal view virtual returns (bytes calldata) {
307         return msg.data;
308     }
309 }
310 
311 
312 /**
313  * @dev Contract module which provides a basic access control mechanism, where
314  * there is an account (an owner) that can be granted exclusive access to
315  * specific functions.
316  *
317  * By default, the owner account will be the one that deploys the contract. This
318  * can later be changed with {transferOwnership}.
319  *
320  * This module is used through inheritance. It will make available the modifier
321  * `onlyOwner`, which can be applied to your functions to restrict their use to
322  * the owner.
323  */
324 abstract contract Ownable is Context {
325     address private _owner;
326 
327     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
328 
329     /**
330      * @dev Initializes the contract setting the deployer as the initial owner.
331      */
332     constructor() {
333         _transferOwnership(_msgSender());
334     }
335 
336     /**
337      * @dev Throws if called by any account other than the owner.
338      */
339     modifier onlyOwner() {
340         _checkOwner();
341         _;
342     }
343 
344     /**
345      * @dev Returns the address of the current owner.
346      */
347     function owner() public view virtual returns (address) {
348         return _owner;
349     }
350 
351     /**
352      * @dev Throws if the sender is not the owner.
353      */
354     function _checkOwner() internal view virtual {
355         require(owner() == _msgSender(), "Ownable: caller is not the owner");
356     }
357 
358     /**
359      * @dev Leaves the contract without owner. It will not be possible to call
360      * `onlyOwner` functions anymore. Can only be called by the current owner.
361      *
362      * NOTE: Renouncing ownership will leave the contract without an owner,
363      * thereby removing any functionality that is only available to the owner.
364      */
365     function renounceOwnership() public virtual onlyOwner {
366         _transferOwnership(address(0));
367     }
368 
369     /**
370      * @dev Transfers ownership of the contract to a new account (`newOwner`).
371      * Can only be called by the current owner.
372      */
373     function transferOwnership(address newOwner) public virtual onlyOwner {
374         require(newOwner != address(0), "Ownable: new owner is the zero address");
375         _transferOwnership(newOwner);
376     }
377 
378     /**
379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
380      * Internal function without access restriction.
381      */
382     function _transferOwnership(address newOwner) internal virtual {
383         address oldOwner = _owner;
384         _owner = newOwner;
385         emit OwnershipTransferred(oldOwner, newOwner);
386     }
387 }
388 
389 
390 /**
391  * @dev Interface of ERC721A.
392  */
393 interface IERC721A {
394     /**
395      * The caller must own the token or be an approved operator.
396      */
397     error ApprovalCallerNotOwnerNorApproved();
398 
399     /**
400      * The token does not exist.
401      */
402     error ApprovalQueryForNonexistentToken();
403 
404     /**
405      * Cannot query the balance for the zero address.
406      */
407     error BalanceQueryForZeroAddress();
408 
409     /**
410      * Cannot mint to the zero address.
411      */
412     error MintToZeroAddress();
413 
414     /**
415      * The quantity of tokens minted must be more than zero.
416      */
417     error MintZeroQuantity();
418 
419     /**
420      * The token does not exist.
421      */
422     error OwnerQueryForNonexistentToken();
423 
424     /**
425      * The caller must own the token or be an approved operator.
426      */
427     error TransferCallerNotOwnerNorApproved();
428 
429     /**
430      * The token must be owned by `from`.
431      */
432     error TransferFromIncorrectOwner();
433 
434     /**
435      * Cannot safely transfer to a contract that does not implement the
436      * ERC721Receiver interface.
437      */
438     error TransferToNonERC721ReceiverImplementer();
439 
440     /**
441      * Cannot transfer to the zero address.
442      */
443     error TransferToZeroAddress();
444 
445     /**
446      * The token does not exist.
447      */
448     error URIQueryForNonexistentToken();
449 
450     /**
451      * The `quantity` minted with ERC2309 exceeds the safety limit.
452      */
453     error MintERC2309QuantityExceedsLimit();
454 
455     /**
456      * The `extraData` cannot be set on an unintialized ownership slot.
457      */
458     error OwnershipNotInitializedForExtraData();
459 
460     // =============================================================
461     //                            STRUCTS
462     // =============================================================
463 
464     struct TokenOwnership {
465         // The address of the owner.
466         address addr;
467         // Stores the start time of ownership with minimal overhead for tokenomics.
468         uint64 startTimestamp;
469         // Whether the token has been burned.
470         bool burned;
471         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
472         uint24 extraData;
473     }
474 
475     // =============================================================
476     //                         TOKEN COUNTERS
477     // =============================================================
478 
479     /**
480      * @dev Returns the total number of tokens in existence.
481      * Burned tokens will reduce the count.
482      * To get the total number of tokens minted, please see {_totalMinted}.
483      */
484     function totalSupply() external view returns (uint256);
485 
486     // =============================================================
487     //                            IERC165
488     // =============================================================
489 
490     /**
491      * @dev Returns true if this contract implements the interface defined by
492      * `interfaceId`. See the corresponding
493      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
494      * to learn more about how these ids are created.
495      *
496      * This function call must use less than 30000 gas.
497      */
498     function supportsInterface(bytes4 interfaceId) external view returns (bool);
499 
500     // =============================================================
501     //                            IERC721
502     // =============================================================
503 
504     /**
505      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
506      */
507     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
511      */
512     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
513 
514     /**
515      * @dev Emitted when `owner` enables or disables
516      * (`approved`) `operator` to manage all of its assets.
517      */
518     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
519 
520     /**
521      * @dev Returns the number of tokens in `owner`'s account.
522      */
523     function balanceOf(address owner) external view returns (uint256 balance);
524 
525     /**
526      * @dev Returns the owner of the `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function ownerOf(uint256 tokenId) external view returns (address owner);
533 
534     /**
535      * @dev Safely transfers `tokenId` token from `from` to `to`,
536      * checking first that contract recipients are aware of the ERC721 protocol
537      * to prevent tokens from being forever locked.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must exist and be owned by `from`.
544      * - If the caller is not `from`, it must be have been allowed to move
545      * this token by either {approve} or {setApprovalForAll}.
546      * - If `to` refers to a smart contract, it must implement
547      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
548      *
549      * Emits a {Transfer} event.
550      */
551     function safeTransferFrom(
552         address from,
553         address to,
554         uint256 tokenId,
555         bytes calldata data
556     ) external payable;
557 
558     /**
559      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
560      */
561     function safeTransferFrom(
562         address from,
563         address to,
564         uint256 tokenId
565     ) external payable;
566 
567     /**
568      * @dev Transfers `tokenId` from `from` to `to`.
569      *
570      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
571      * whenever possible.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must be owned by `from`.
578      * - If the caller is not `from`, it must be approved to move this token
579      * by either {approve} or {setApprovalForAll}.
580      *
581      * Emits a {Transfer} event.
582      */
583     function transferFrom(
584         address from,
585         address to,
586         uint256 tokenId
587     ) external payable;
588 
589     /**
590      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
591      * The approval is cleared when the token is transferred.
592      *
593      * Only a single account can be approved at a time, so approving the
594      * zero address clears previous approvals.
595      *
596      * Requirements:
597      *
598      * - The caller must own the token or be an approved operator.
599      * - `tokenId` must exist.
600      *
601      * Emits an {Approval} event.
602      */
603     function approve(address to, uint256 tokenId) external payable;
604 
605     /**
606      * @dev Approve or remove `operator` as an operator for the caller.
607      * Operators can call {transferFrom} or {safeTransferFrom}
608      * for any token owned by the caller.
609      *
610      * Requirements:
611      *
612      * - The `operator` cannot be the caller.
613      *
614      * Emits an {ApprovalForAll} event.
615      */
616     function setApprovalForAll(address operator, bool _approved) external;
617 
618     /**
619      * @dev Returns the account approved for `tokenId` token.
620      *
621      * Requirements:
622      *
623      * - `tokenId` must exist.
624      */
625     function getApproved(uint256 tokenId) external view returns (address operator);
626 
627     /**
628      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
629      *
630      * See {setApprovalForAll}.
631      */
632     function isApprovedForAll(address owner, address operator) external view returns (bool);
633 
634     // =============================================================
635     //                        IERC721Metadata
636     // =============================================================
637 
638     /**
639      * @dev Returns the token collection name.
640      */
641     function name() external view returns (string memory);
642 
643     /**
644      * @dev Returns the token collection symbol.
645      */
646     function symbol() external view returns (string memory);
647 
648     /**
649      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
650      */
651     function tokenURI(uint256 tokenId) external view returns (string memory);
652 
653     // =============================================================
654     //                           IERC2309
655     // =============================================================
656 
657     /**
658      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
659      * (inclusive) is transferred from `from` to `to`, as defined in the
660      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
661      *
662      * See {_mintERC2309} for more details.
663      */
664     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
665 }
666 
667 
668 /**
669  * @dev Interface of ERC721 token receiver.
670  */
671 interface ERC721A__IERC721Receiver {
672     function onERC721Received(
673         address operator,
674         address from,
675         uint256 tokenId,
676         bytes calldata data
677     ) external returns (bytes4);
678 }
679 
680 /**
681  * @title ERC721A
682  *
683  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
684  * Non-Fungible Token Standard, including the Metadata extension.
685  * Optimized for lower gas during batch mints.
686  *
687  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
688  * starting from `_startTokenId()`.
689  *
690  * Assumptions:
691  *
692  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
693  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
694  */
695 contract ERC721A is IERC721A {
696     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
697     struct TokenApprovalRef {
698         address value;
699     }
700 
701     // =============================================================
702     //                           CONSTANTS
703     // =============================================================
704 
705     // Mask of an entry in packed address data.
706     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
707 
708     // The bit position of `numberMinted` in packed address data.
709     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
710 
711     // The bit position of `numberBurned` in packed address data.
712     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
713 
714     // The bit position of `aux` in packed address data.
715     uint256 private constant _BITPOS_AUX = 192;
716 
717     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
718     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
719 
720     // The bit position of `startTimestamp` in packed ownership.
721     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
722 
723     // The bit mask of the `burned` bit in packed ownership.
724     uint256 private constant _BITMASK_BURNED = 1 << 224;
725 
726     // The bit position of the `nextInitialized` bit in packed ownership.
727     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
728 
729     // The bit mask of the `nextInitialized` bit in packed ownership.
730     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
731 
732     // The bit position of `extraData` in packed ownership.
733     uint256 private constant _BITPOS_EXTRA_DATA = 232;
734 
735     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
736     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
737 
738     // The mask of the lower 160 bits for addresses.
739     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
740 
741     // The maximum `quantity` that can be minted with {_mintERC2309}.
742     // This limit is to prevent overflows on the address data entries.
743     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
744     // is required to cause an overflow, which is unrealistic.
745     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
746 
747     // The `Transfer` event signature is given by:
748     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
749     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
750         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
751 
752     // =============================================================
753     //                            STORAGE
754     // =============================================================
755 
756     // The next token ID to be minted.
757     uint256 private _currentIndex;
758 
759     // The number of tokens burned.
760     uint256 private _burnCounter;
761 
762     // Token name
763     string private _name;
764 
765     // Token symbol
766     string private _symbol;
767 
768     // Mapping from token ID to ownership details
769     // An empty struct value does not necessarily mean the token is unowned.
770     // See {_packedOwnershipOf} implementation for details.
771     //
772     // Bits Layout:
773     // - [0..159]   `addr`
774     // - [160..223] `startTimestamp`
775     // - [224]      `burned`
776     // - [225]      `nextInitialized`
777     // - [232..255] `extraData`
778     mapping(uint256 => uint256) private _packedOwnerships;
779 
780     // Mapping owner address to address data.
781     //
782     // Bits Layout:
783     // - [0..63]    `balance`
784     // - [64..127]  `numberMinted`
785     // - [128..191] `numberBurned`
786     // - [192..255] `aux`
787     mapping(address => uint256) private _packedAddressData;
788 
789     // Mapping from token ID to approved address.
790     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
791 
792     // Mapping from owner to operator approvals
793     mapping(address => mapping(address => bool)) private _operatorApprovals;
794 
795     // =============================================================
796     //                          CONSTRUCTOR
797     // =============================================================
798 
799     constructor(string memory name_, string memory symbol_) {
800         _name = name_;
801         _symbol = symbol_;
802         _currentIndex = _startTokenId();
803     }
804 
805     // =============================================================
806     //                   TOKEN COUNTING OPERATIONS
807     // =============================================================
808 
809     /**
810      * @dev Returns the starting token ID.
811      * To change the starting token ID, please override this function.
812      */
813     function _startTokenId() internal view virtual returns (uint256) {
814         return 0;
815     }
816 
817     /**
818      * @dev Returns the next token ID to be minted.
819      */
820     function _nextTokenId() internal view virtual returns (uint256) {
821         return _currentIndex;
822     }
823 
824     /**
825      * @dev Returns the total number of tokens in existence.
826      * Burned tokens will reduce the count.
827      * To get the total number of tokens minted, please see {_totalMinted}.
828      */
829     function totalSupply() public view virtual override returns (uint256) {
830         // Counter underflow is impossible as _burnCounter cannot be incremented
831         // more than `_currentIndex - _startTokenId()` times.
832         unchecked {
833             return _currentIndex - _burnCounter - _startTokenId();
834         }
835     }
836 
837     /**
838      * @dev Returns the total amount of tokens minted in the contract.
839      */
840     function _totalMinted() internal view virtual returns (uint256) {
841         // Counter underflow is impossible as `_currentIndex` does not decrement,
842         // and it is initialized to `_startTokenId()`.
843         unchecked {
844             return _currentIndex - _startTokenId();
845         }
846     }
847 
848     /**
849      * @dev Returns the total number of tokens burned.
850      */
851     function _totalBurned() internal view virtual returns (uint256) {
852         return _burnCounter;
853     }
854 
855     // =============================================================
856     //                    ADDRESS DATA OPERATIONS
857     // =============================================================
858 
859     /**
860      * @dev Returns the number of tokens in `owner`'s account.
861      */
862     function balanceOf(address owner) public view virtual override returns (uint256) {
863         if (owner == address(0)) revert BalanceQueryForZeroAddress();
864         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
865     }
866 
867     /**
868      * Returns the number of tokens minted by `owner`.
869      */
870     function _numberMinted(address owner) internal view returns (uint256) {
871         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
872     }
873 
874     /**
875      * Returns the number of tokens burned by or on behalf of `owner`.
876      */
877     function _numberBurned(address owner) internal view returns (uint256) {
878         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
879     }
880 
881     /**
882      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
883      */
884     function _getAux(address owner) internal view returns (uint64) {
885         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
886     }
887 
888     /**
889      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
890      * If there are multiple variables, please pack them into a uint64.
891      */
892     function _setAux(address owner, uint64 aux) internal virtual {
893         uint256 packed = _packedAddressData[owner];
894         uint256 auxCasted;
895         // Cast `aux` with assembly to avoid redundant masking.
896         assembly {
897             auxCasted := aux
898         }
899         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
900         _packedAddressData[owner] = packed;
901     }
902 
903     // =============================================================
904     //                            IERC165
905     // =============================================================
906 
907     /**
908      * @dev Returns true if this contract implements the interface defined by
909      * `interfaceId`. See the corresponding
910      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
911      * to learn more about how these ids are created.
912      *
913      * This function call must use less than 30000 gas.
914      */
915     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
916         // The interface IDs are constants representing the first 4 bytes
917         // of the XOR of all function selectors in the interface.
918         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
919         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
920         return
921             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
922             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
923             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
924     }
925 
926     // =============================================================
927     //                        IERC721Metadata
928     // =============================================================
929 
930     /**
931      * @dev Returns the token collection name.
932      */
933     function name() public view virtual override returns (string memory) {
934         return _name;
935     }
936 
937     /**
938      * @dev Returns the token collection symbol.
939      */
940     function symbol() public view virtual override returns (string memory) {
941         return _symbol;
942     }
943 
944     /**
945      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
946      */
947     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
948         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
949 
950         string memory baseURI = _baseURI();
951         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
952     }
953 
954     /**
955      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
956      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
957      * by default, it can be overridden in child contracts.
958      */
959     function _baseURI() internal view virtual returns (string memory) {
960         return '';
961     }
962 
963     // =============================================================
964     //                     OWNERSHIPS OPERATIONS
965     // =============================================================
966 
967     /**
968      * @dev Returns the owner of the `tokenId` token.
969      *
970      * Requirements:
971      *
972      * - `tokenId` must exist.
973      */
974     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
975         return address(uint160(_packedOwnershipOf(tokenId)));
976     }
977 
978     /**
979      * @dev Gas spent here starts off proportional to the maximum mint batch size.
980      * It gradually moves to O(1) as tokens get transferred around over time.
981      */
982     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
983         return _unpackedOwnership(_packedOwnershipOf(tokenId));
984     }
985 
986     /**
987      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
988      */
989     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
990         return _unpackedOwnership(_packedOwnerships[index]);
991     }
992 
993     /**
994      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
995      */
996     function _initializeOwnershipAt(uint256 index) internal virtual {
997         if (_packedOwnerships[index] == 0) {
998             _packedOwnerships[index] = _packedOwnershipOf(index);
999         }
1000     }
1001 
1002     /**
1003      * Returns the packed ownership data of `tokenId`.
1004      */
1005     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1006         uint256 curr = tokenId;
1007 
1008         unchecked {
1009             if (_startTokenId() <= curr)
1010                 if (curr < _currentIndex) {
1011                     uint256 packed = _packedOwnerships[curr];
1012                     // If not burned.
1013                     if (packed & _BITMASK_BURNED == 0) {
1014                         // Invariant:
1015                         // There will always be an initialized ownership slot
1016                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1017                         // before an unintialized ownership slot
1018                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1019                         // Hence, `curr` will not underflow.
1020                         //
1021                         // We can directly compare the packed value.
1022                         // If the address is zero, packed will be zero.
1023                         while (packed == 0) {
1024                             packed = _packedOwnerships[--curr];
1025                         }
1026                         return packed;
1027                     }
1028                 }
1029         }
1030         revert OwnerQueryForNonexistentToken();
1031     }
1032 
1033     /**
1034      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1035      */
1036     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1037         ownership.addr = address(uint160(packed));
1038         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1039         ownership.burned = packed & _BITMASK_BURNED != 0;
1040         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1041     }
1042 
1043     /**
1044      * @dev Packs ownership data into a single uint256.
1045      */
1046     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1047         assembly {
1048             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1049             owner := and(owner, _BITMASK_ADDRESS)
1050             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1051             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1052         }
1053     }
1054 
1055     /**
1056      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1057      */
1058     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1059         // For branchless setting of the `nextInitialized` flag.
1060         assembly {
1061             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1062             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1063         }
1064     }
1065 
1066     // =============================================================
1067     //                      APPROVAL OPERATIONS
1068     // =============================================================
1069 
1070     /**
1071      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1072      * The approval is cleared when the token is transferred.
1073      *
1074      * Only a single account can be approved at a time, so approving the
1075      * zero address clears previous approvals.
1076      *
1077      * Requirements:
1078      *
1079      * - The caller must own the token or be an approved operator.
1080      * - `tokenId` must exist.
1081      *
1082      * Emits an {Approval} event.
1083      */
1084     function approve(address to, uint256 tokenId) public payable virtual override {
1085         address owner = ownerOf(tokenId);
1086 
1087         if (_msgSenderERC721A() != owner)
1088             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1089                 revert ApprovalCallerNotOwnerNorApproved();
1090             }
1091 
1092         _tokenApprovals[tokenId].value = to;
1093         emit Approval(owner, to, tokenId);
1094     }
1095 
1096     /**
1097      * @dev Returns the account approved for `tokenId` token.
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must exist.
1102      */
1103     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1104         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1105 
1106         return _tokenApprovals[tokenId].value;
1107     }
1108 
1109     /**
1110      * @dev Approve or remove `operator` as an operator for the caller.
1111      * Operators can call {transferFrom} or {safeTransferFrom}
1112      * for any token owned by the caller.
1113      *
1114      * Requirements:
1115      *
1116      * - The `operator` cannot be the caller.
1117      *
1118      * Emits an {ApprovalForAll} event.
1119      */
1120     function setApprovalForAll(address operator, bool approved) public virtual override {
1121         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1122         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1123     }
1124 
1125     /**
1126      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1127      *
1128      * See {setApprovalForAll}.
1129      */
1130     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1131         return _operatorApprovals[owner][operator];
1132     }
1133 
1134     /**
1135      * @dev Returns whether `tokenId` exists.
1136      *
1137      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1138      *
1139      * Tokens start existing when they are minted. See {_mint}.
1140      */
1141     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1142         return
1143             _startTokenId() <= tokenId &&
1144             tokenId < _currentIndex && // If within bounds,
1145             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1146     }
1147 
1148     /**
1149      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1150      */
1151     function _isSenderApprovedOrOwner(
1152         address approvedAddress,
1153         address owner,
1154         address msgSender
1155     ) private pure returns (bool result) {
1156         assembly {
1157             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1158             owner := and(owner, _BITMASK_ADDRESS)
1159             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1160             msgSender := and(msgSender, _BITMASK_ADDRESS)
1161             // `msgSender == owner || msgSender == approvedAddress`.
1162             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1163         }
1164     }
1165 
1166     /**
1167      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1168      */
1169     function _getApprovedSlotAndAddress(uint256 tokenId)
1170         private
1171         view
1172         returns (uint256 approvedAddressSlot, address approvedAddress)
1173     {
1174         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1175         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1176         assembly {
1177             approvedAddressSlot := tokenApproval.slot
1178             approvedAddress := sload(approvedAddressSlot)
1179         }
1180     }
1181 
1182     // =============================================================
1183     //                      TRANSFER OPERATIONS
1184     // =============================================================
1185 
1186     /**
1187      * @dev Transfers `tokenId` from `from` to `to`.
1188      *
1189      * Requirements:
1190      *
1191      * - `from` cannot be the zero address.
1192      * - `to` cannot be the zero address.
1193      * - `tokenId` token must be owned by `from`.
1194      * - If the caller is not `from`, it must be approved to move this token
1195      * by either {approve} or {setApprovalForAll}.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function transferFrom(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) public payable virtual override {
1204         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1205 
1206         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1207 
1208         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1209 
1210         // The nested ifs save around 20+ gas over a compound boolean condition.
1211         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1212             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1213 
1214         if (to == address(0)) revert TransferToZeroAddress();
1215 
1216         _beforeTokenTransfers(from, to, tokenId, 1);
1217 
1218         // Clear approvals from the previous owner.
1219         assembly {
1220             if approvedAddress {
1221                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1222                 sstore(approvedAddressSlot, 0)
1223             }
1224         }
1225 
1226         // Underflow of the sender's balance is impossible because we check for
1227         // ownership above and the recipient's balance can't realistically overflow.
1228         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1229         unchecked {
1230             // We can directly increment and decrement the balances.
1231             --_packedAddressData[from]; // Updates: `balance -= 1`.
1232             ++_packedAddressData[to]; // Updates: `balance += 1`.
1233 
1234             // Updates:
1235             // - `address` to the next owner.
1236             // - `startTimestamp` to the timestamp of transfering.
1237             // - `burned` to `false`.
1238             // - `nextInitialized` to `true`.
1239             _packedOwnerships[tokenId] = _packOwnershipData(
1240                 to,
1241                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1242             );
1243 
1244             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1245             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1246                 uint256 nextTokenId = tokenId + 1;
1247                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1248                 if (_packedOwnerships[nextTokenId] == 0) {
1249                     // If the next slot is within bounds.
1250                     if (nextTokenId != _currentIndex) {
1251                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1252                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1253                     }
1254                 }
1255             }
1256         }
1257 
1258         emit Transfer(from, to, tokenId);
1259         _afterTokenTransfers(from, to, tokenId, 1);
1260     }
1261 
1262     /**
1263      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1264      */
1265     function safeTransferFrom(
1266         address from,
1267         address to,
1268         uint256 tokenId
1269     ) public payable virtual override {
1270         safeTransferFrom(from, to, tokenId, '');
1271     }
1272 
1273     /**
1274      * @dev Safely transfers `tokenId` token from `from` to `to`.
1275      *
1276      * Requirements:
1277      *
1278      * - `from` cannot be the zero address.
1279      * - `to` cannot be the zero address.
1280      * - `tokenId` token must exist and be owned by `from`.
1281      * - If the caller is not `from`, it must be approved to move this token
1282      * by either {approve} or {setApprovalForAll}.
1283      * - If `to` refers to a smart contract, it must implement
1284      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1285      *
1286      * Emits a {Transfer} event.
1287      */
1288     function safeTransferFrom(
1289         address from,
1290         address to,
1291         uint256 tokenId,
1292         bytes memory _data
1293     ) public payable virtual override {
1294         transferFrom(from, to, tokenId);
1295         if (to.code.length != 0)
1296             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1297                 revert TransferToNonERC721ReceiverImplementer();
1298             }
1299     }
1300 
1301     /**
1302      * @dev Hook that is called before a set of serially-ordered token IDs
1303      * are about to be transferred. This includes minting.
1304      * And also called before burning one token.
1305      *
1306      * `startTokenId` - the first token ID to be transferred.
1307      * `quantity` - the amount to be transferred.
1308      *
1309      * Calling conditions:
1310      *
1311      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1312      * transferred to `to`.
1313      * - When `from` is zero, `tokenId` will be minted for `to`.
1314      * - When `to` is zero, `tokenId` will be burned by `from`.
1315      * - `from` and `to` are never both zero.
1316      */
1317     function _beforeTokenTransfers(
1318         address from,
1319         address to,
1320         uint256 startTokenId,
1321         uint256 quantity
1322     ) internal virtual {}
1323 
1324     /**
1325      * @dev Hook that is called after a set of serially-ordered token IDs
1326      * have been transferred. This includes minting.
1327      * And also called after one token has been burned.
1328      *
1329      * `startTokenId` - the first token ID to be transferred.
1330      * `quantity` - the amount to be transferred.
1331      *
1332      * Calling conditions:
1333      *
1334      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1335      * transferred to `to`.
1336      * - When `from` is zero, `tokenId` has been minted for `to`.
1337      * - When `to` is zero, `tokenId` has been burned by `from`.
1338      * - `from` and `to` are never both zero.
1339      */
1340     function _afterTokenTransfers(
1341         address from,
1342         address to,
1343         uint256 startTokenId,
1344         uint256 quantity
1345     ) internal virtual {}
1346 
1347     /**
1348      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1349      *
1350      * `from` - Previous owner of the given token ID.
1351      * `to` - Target address that will receive the token.
1352      * `tokenId` - Token ID to be transferred.
1353      * `_data` - Optional data to send along with the call.
1354      *
1355      * Returns whether the call correctly returned the expected magic value.
1356      */
1357     function _checkContractOnERC721Received(
1358         address from,
1359         address to,
1360         uint256 tokenId,
1361         bytes memory _data
1362     ) private returns (bool) {
1363         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1364             bytes4 retval
1365         ) {
1366             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1367         } catch (bytes memory reason) {
1368             if (reason.length == 0) {
1369                 revert TransferToNonERC721ReceiverImplementer();
1370             } else {
1371                 assembly {
1372                     revert(add(32, reason), mload(reason))
1373                 }
1374             }
1375         }
1376     }
1377 
1378     // =============================================================
1379     //                        MINT OPERATIONS
1380     // =============================================================
1381 
1382     /**
1383      * @dev Mints `quantity` tokens and transfers them to `to`.
1384      *
1385      * Requirements:
1386      *
1387      * - `to` cannot be the zero address.
1388      * - `quantity` must be greater than 0.
1389      *
1390      * Emits a {Transfer} event for each mint.
1391      */
1392     function _mint(address to, uint256 quantity) internal virtual {
1393         uint256 startTokenId = _currentIndex;
1394         if (quantity == 0) revert MintZeroQuantity();
1395 
1396         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1397 
1398         // Overflows are incredibly unrealistic.
1399         // `balance` and `numberMinted` have a maximum limit of 2**64.
1400         // `tokenId` has a maximum limit of 2**256.
1401         unchecked {
1402             // Updates:
1403             // - `balance += quantity`.
1404             // - `numberMinted += quantity`.
1405             //
1406             // We can directly add to the `balance` and `numberMinted`.
1407             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1408 
1409             // Updates:
1410             // - `address` to the owner.
1411             // - `startTimestamp` to the timestamp of minting.
1412             // - `burned` to `false`.
1413             // - `nextInitialized` to `quantity == 1`.
1414             _packedOwnerships[startTokenId] = _packOwnershipData(
1415                 to,
1416                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1417             );
1418 
1419             uint256 toMasked;
1420             uint256 end = startTokenId + quantity;
1421 
1422             // Use assembly to loop and emit the `Transfer` event for gas savings.
1423             // The duplicated `log4` removes an extra check and reduces stack juggling.
1424             // The assembly, together with the surrounding Solidity code, have been
1425             // delicately arranged to nudge the compiler into producing optimized opcodes.
1426             assembly {
1427                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1428                 toMasked := and(to, _BITMASK_ADDRESS)
1429                 // Emit the `Transfer` event.
1430                 log4(
1431                     0, // Start of data (0, since no data).
1432                     0, // End of data (0, since no data).
1433                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1434                     0, // `address(0)`.
1435                     toMasked, // `to`.
1436                     startTokenId // `tokenId`.
1437                 )
1438 
1439                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1440                 // that overflows uint256 will make the loop run out of gas.
1441                 // The compiler will optimize the `iszero` away for performance.
1442                 for {
1443                     let tokenId := add(startTokenId, 1)
1444                 } iszero(eq(tokenId, end)) {
1445                     tokenId := add(tokenId, 1)
1446                 } {
1447                     // Emit the `Transfer` event. Similar to above.
1448                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1449                 }
1450             }
1451             if (toMasked == 0) revert MintToZeroAddress();
1452 
1453             _currentIndex = end;
1454         }
1455         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1456     }
1457 
1458     /**
1459      * @dev Mints `quantity` tokens and transfers them to `to`.
1460      *
1461      * This function is intended for efficient minting only during contract creation.
1462      *
1463      * It emits only one {ConsecutiveTransfer} as defined in
1464      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1465      * instead of a sequence of {Transfer} event(s).
1466      *
1467      * Calling this function outside of contract creation WILL make your contract
1468      * non-compliant with the ERC721 standard.
1469      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1470      * {ConsecutiveTransfer} event is only permissible during contract creation.
1471      *
1472      * Requirements:
1473      *
1474      * - `to` cannot be the zero address.
1475      * - `quantity` must be greater than 0.
1476      *
1477      * Emits a {ConsecutiveTransfer} event.
1478      */
1479     function _mintERC2309(address to, uint256 quantity) internal virtual {
1480         uint256 startTokenId = _currentIndex;
1481         if (to == address(0)) revert MintToZeroAddress();
1482         if (quantity == 0) revert MintZeroQuantity();
1483         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1484 
1485         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1486 
1487         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1488         unchecked {
1489             // Updates:
1490             // - `balance += quantity`.
1491             // - `numberMinted += quantity`.
1492             //
1493             // We can directly add to the `balance` and `numberMinted`.
1494             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1495 
1496             // Updates:
1497             // - `address` to the owner.
1498             // - `startTimestamp` to the timestamp of minting.
1499             // - `burned` to `false`.
1500             // - `nextInitialized` to `quantity == 1`.
1501             _packedOwnerships[startTokenId] = _packOwnershipData(
1502                 to,
1503                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1504             );
1505 
1506             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1507 
1508             _currentIndex = startTokenId + quantity;
1509         }
1510         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1511     }
1512 
1513     /**
1514      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1515      *
1516      * Requirements:
1517      *
1518      * - If `to` refers to a smart contract, it must implement
1519      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1520      * - `quantity` must be greater than 0.
1521      *
1522      * See {_mint}.
1523      *
1524      * Emits a {Transfer} event for each mint.
1525      */
1526     function _safeMint(
1527         address to,
1528         uint256 quantity,
1529         bytes memory _data
1530     ) internal virtual {
1531         _mint(to, quantity);
1532 
1533         unchecked {
1534             if (to.code.length != 0) {
1535                 uint256 end = _currentIndex;
1536                 uint256 index = end - quantity;
1537                 do {
1538                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1539                         revert TransferToNonERC721ReceiverImplementer();
1540                     }
1541                 } while (index < end);
1542                 // Reentrancy protection.
1543                 if (_currentIndex != end) revert();
1544             }
1545         }
1546     }
1547 
1548     /**
1549      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1550      */
1551     function _safeMint(address to, uint256 quantity) internal virtual {
1552         _safeMint(to, quantity, '');
1553     }
1554 
1555     // =============================================================
1556     //                        BURN OPERATIONS
1557     // =============================================================
1558 
1559     /**
1560      * @dev Equivalent to `_burn(tokenId, false)`.
1561      */
1562     function _burn(uint256 tokenId) internal virtual {
1563         _burn(tokenId, false);
1564     }
1565 
1566     /**
1567      * @dev Destroys `tokenId`.
1568      * The approval is cleared when the token is burned.
1569      *
1570      * Requirements:
1571      *
1572      * - `tokenId` must exist.
1573      *
1574      * Emits a {Transfer} event.
1575      */
1576     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1577         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1578 
1579         address from = address(uint160(prevOwnershipPacked));
1580 
1581         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1582 
1583         if (approvalCheck) {
1584             // The nested ifs save around 20+ gas over a compound boolean condition.
1585             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1586                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1587         }
1588 
1589         _beforeTokenTransfers(from, address(0), tokenId, 1);
1590 
1591         // Clear approvals from the previous owner.
1592         assembly {
1593             if approvedAddress {
1594                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1595                 sstore(approvedAddressSlot, 0)
1596             }
1597         }
1598 
1599         // Underflow of the sender's balance is impossible because we check for
1600         // ownership above and the recipient's balance can't realistically overflow.
1601         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1602         unchecked {
1603             // Updates:
1604             // - `balance -= 1`.
1605             // - `numberBurned += 1`.
1606             //
1607             // We can directly decrement the balance, and increment the number burned.
1608             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1609             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1610 
1611             // Updates:
1612             // - `address` to the last owner.
1613             // - `startTimestamp` to the timestamp of burning.
1614             // - `burned` to `true`.
1615             // - `nextInitialized` to `true`.
1616             _packedOwnerships[tokenId] = _packOwnershipData(
1617                 from,
1618                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1619             );
1620 
1621             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1622             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1623                 uint256 nextTokenId = tokenId + 1;
1624                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1625                 if (_packedOwnerships[nextTokenId] == 0) {
1626                     // If the next slot is within bounds.
1627                     if (nextTokenId != _currentIndex) {
1628                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1629                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1630                     }
1631                 }
1632             }
1633         }
1634 
1635         emit Transfer(from, address(0), tokenId);
1636         _afterTokenTransfers(from, address(0), tokenId, 1);
1637 
1638         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1639         unchecked {
1640             _burnCounter++;
1641         }
1642     }
1643 
1644     // =============================================================
1645     //                     EXTRA DATA OPERATIONS
1646     // =============================================================
1647 
1648     /**
1649      * @dev Directly sets the extra data for the ownership data `index`.
1650      */
1651     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1652         uint256 packed = _packedOwnerships[index];
1653         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1654         uint256 extraDataCasted;
1655         // Cast `extraData` with assembly to avoid redundant masking.
1656         assembly {
1657             extraDataCasted := extraData
1658         }
1659         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1660         _packedOwnerships[index] = packed;
1661     }
1662 
1663     /**
1664      * @dev Called during each token transfer to set the 24bit `extraData` field.
1665      * Intended to be overridden by the cosumer contract.
1666      *
1667      * `previousExtraData` - the value of `extraData` before transfer.
1668      *
1669      * Calling conditions:
1670      *
1671      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1672      * transferred to `to`.
1673      * - When `from` is zero, `tokenId` will be minted for `to`.
1674      * - When `to` is zero, `tokenId` will be burned by `from`.
1675      * - `from` and `to` are never both zero.
1676      */
1677     function _extraData(
1678         address from,
1679         address to,
1680         uint24 previousExtraData
1681     ) internal view virtual returns (uint24) {}
1682 
1683     /**
1684      * @dev Returns the next extra data for the packed ownership data.
1685      * The returned result is shifted into position.
1686      */
1687     function _nextExtraData(
1688         address from,
1689         address to,
1690         uint256 prevOwnershipPacked
1691     ) private view returns (uint256) {
1692         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1693         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1694     }
1695 
1696     // =============================================================
1697     //                       OTHER OPERATIONS
1698     // =============================================================
1699 
1700     /**
1701      * @dev Returns the message sender (defaults to `msg.sender`).
1702      *
1703      * If you are writing GSN compatible contracts, you need to override this function.
1704      */
1705     function _msgSenderERC721A() internal view virtual returns (address) {
1706         return msg.sender;
1707     }
1708 
1709     /**
1710      * @dev Converts a uint256 to its ASCII string decimal representation.
1711      */
1712     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1713         assembly {
1714             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1715             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1716             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1717             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1718             let m := add(mload(0x40), 0xa0)
1719             // Update the free memory pointer to allocate.
1720             mstore(0x40, m)
1721             // Assign the `str` to the end.
1722             str := sub(m, 0x20)
1723             // Zeroize the slot after the string.
1724             mstore(str, 0)
1725 
1726             // Cache the end of the memory to calculate the length later.
1727             let end := str
1728 
1729             // We write the string from rightmost digit to leftmost digit.
1730             // The following is essentially a do-while loop that also handles the zero case.
1731             // prettier-ignore
1732             for { let temp := value } 1 {} {
1733                 str := sub(str, 1)
1734                 // Write the character to the pointer.
1735                 // The ASCII index of the '0' character is 48.
1736                 mstore8(str, add(48, mod(temp, 10)))
1737                 // Keep dividing `temp` until zero.
1738                 temp := div(temp, 10)
1739                 // prettier-ignore
1740                 if iszero(temp) { break }
1741             }
1742 
1743             let length := sub(end, str)
1744             // Move the pointer 32 bytes leftwards to make room for the length.
1745             str := sub(str, 0x20)
1746             // Store the length.
1747             mstore(str, length)
1748         }
1749     }
1750 }
1751 
1752 
1753 
1754 
1755 
1756 contract NFDSecretKeys is ERC721A, Ownable, ReentrancyGuard {
1757 
1758     uint256 public constant MAX_SUPPLY = 3333;
1759 
1760     bytes32 public phase1Root;
1761     bytes32 public phase2Root;
1762 
1763     uint256 public currentPhase;
1764 
1765     mapping(address => bool) private _hasMinted;
1766 
1767     // metadata URI
1768     string private _baseTokenURI;
1769 
1770 
1771     function _baseURI() internal view virtual override returns (string memory) {
1772         return _baseTokenURI;
1773     }
1774 
1775     function setBaseURI(string calldata baseURI) external onlyOwner {
1776         _baseTokenURI = baseURI;
1777     }
1778 
1779     constructor() ERC721A("NFD Keys", "NFDKEYS") {
1780         _mint(owner(), 1);
1781         currentPhase = 0;
1782     }
1783 
1784     modifier callerIsUser() {
1785         require(tx.origin == msg.sender, "The caller is another contract");
1786         _;
1787     }
1788 
1789     modifier checkAlreadyMinted() {
1790         require(!_hasMinted[msg.sender], "This account has already minted an NFT");
1791         _;
1792 }
1793 
1794     modifier checkProof(bytes32[] memory proof) {
1795         if(currentPhase == 3 || currentPhase == 0) {
1796             _;
1797         } else {
1798             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1799             require(MerkleProof.verify(proof, currentPhase == 1 ? phase1Root : phase2Root, leaf), "Invalid proof");
1800             _;
1801         }
1802     }
1803 
1804     function setRootPhase1(bytes32 _merkleRoot) public onlyOwner {
1805         phase1Root = _merkleRoot;
1806     }
1807 
1808     function setRootPhase2(bytes32 _merkleRoot) public onlyOwner {
1809         phase2Root = _merkleRoot;
1810     }
1811 
1812     function setPhase(uint256 phase) public onlyOwner {
1813         require(phase < 4, "Incorrect phase.");
1814         require(currentPhase != phase, "Phase already live.");
1815         currentPhase = phase;
1816     }
1817 
1818     function treasuryMint(address to, uint256 mintCount) public onlyOwner {
1819         require(totalSupply() + mintCount <= MAX_SUPPLY, "Cant mint more than max supply");
1820         _mint(to, mintCount);
1821     }
1822 
1823     function mint(bytes32[] memory proof) external callerIsUser checkAlreadyMinted checkProof(proof)  {
1824         require(currentPhase != 0, "Mint not started!");
1825         require(totalSupply() + 1 <= MAX_SUPPLY, "Cant mint more than max supply");
1826         _hasMinted[msg.sender] = true;
1827         _mint(msg.sender, 1);
1828     }
1829 
1830     function hasMinted(address account) public view returns (bool) {
1831         return _hasMinted[account];
1832     }
1833 }