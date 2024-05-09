1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         _nonReentrantBefore();
56         _;
57         _nonReentrantAfter();
58     }
59 
60     function _nonReentrantBefore() private {
61         // On the first call to nonReentrant, _status will be _NOT_ENTERED
62         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
63 
64         // Any calls to nonReentrant after this point will fail
65         _status = _ENTERED;
66     }
67 
68     function _nonReentrantAfter() private {
69         // By storing the original value once again, a refund is triggered (see
70         // https://eips.ethereum.org/EIPS/eip-2200)
71         _status = _NOT_ENTERED;
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
76 
77 
78 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev These functions deal with verification of Merkle Tree proofs.
84  *
85  * The tree and the proofs can be generated using our
86  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
87  * You will find a quickstart guide in the readme.
88  *
89  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
90  * hashing, or use a hash function other than keccak256 for hashing leaves.
91  * This is because the concatenation of a sorted pair of internal nodes in
92  * the merkle tree could be reinterpreted as a leaf value.
93  * OpenZeppelin's JavaScript library generates merkle trees that are safe
94  * against this attack out of the box.
95  */
96 library MerkleProof {
97     /**
98      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
99      * defined by `root`. For this, a `proof` must be provided, containing
100      * sibling hashes on the branch from the leaf to the root of the tree. Each
101      * pair of leaves and each pair of pre-images are assumed to be sorted.
102      */
103     function verify(
104         bytes32[] memory proof,
105         bytes32 root,
106         bytes32 leaf
107     ) internal pure returns (bool) {
108         return processProof(proof, leaf) == root;
109     }
110 
111     /**
112      * @dev Calldata version of {verify}
113      *
114      * _Available since v4.7._
115      */
116     function verifyCalldata(
117         bytes32[] calldata proof,
118         bytes32 root,
119         bytes32 leaf
120     ) internal pure returns (bool) {
121         return processProofCalldata(proof, leaf) == root;
122     }
123 
124     /**
125      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
126      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
127      * hash matches the root of the tree. When processing the proof, the pairs
128      * of leafs & pre-images are assumed to be sorted.
129      *
130      * _Available since v4.4._
131      */
132     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
133         bytes32 computedHash = leaf;
134         for (uint256 i = 0; i < proof.length; i++) {
135             computedHash = _hashPair(computedHash, proof[i]);
136         }
137         return computedHash;
138     }
139 
140     /**
141      * @dev Calldata version of {processProof}
142      *
143      * _Available since v4.7._
144      */
145     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
146         bytes32 computedHash = leaf;
147         for (uint256 i = 0; i < proof.length; i++) {
148             computedHash = _hashPair(computedHash, proof[i]);
149         }
150         return computedHash;
151     }
152 
153     /**
154      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
155      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
156      *
157      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
158      *
159      * _Available since v4.7._
160      */
161     function multiProofVerify(
162         bytes32[] memory proof,
163         bool[] memory proofFlags,
164         bytes32 root,
165         bytes32[] memory leaves
166     ) internal pure returns (bool) {
167         return processMultiProof(proof, proofFlags, leaves) == root;
168     }
169 
170     /**
171      * @dev Calldata version of {multiProofVerify}
172      *
173      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
174      *
175      * _Available since v4.7._
176      */
177     function multiProofVerifyCalldata(
178         bytes32[] calldata proof,
179         bool[] calldata proofFlags,
180         bytes32 root,
181         bytes32[] memory leaves
182     ) internal pure returns (bool) {
183         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
184     }
185 
186     /**
187      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
188      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
189      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
190      * respectively.
191      *
192      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
193      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
194      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
195      *
196      * _Available since v4.7._
197      */
198     function processMultiProof(
199         bytes32[] memory proof,
200         bool[] memory proofFlags,
201         bytes32[] memory leaves
202     ) internal pure returns (bytes32 merkleRoot) {
203         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
204         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
205         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
206         // the merkle tree.
207         uint256 leavesLen = leaves.length;
208         uint256 totalHashes = proofFlags.length;
209 
210         // Check proof validity.
211         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
212 
213         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
214         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
215         bytes32[] memory hashes = new bytes32[](totalHashes);
216         uint256 leafPos = 0;
217         uint256 hashPos = 0;
218         uint256 proofPos = 0;
219         // At each step, we compute the next hash using two values:
220         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
221         //   get the next hash.
222         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
223         //   `proof` array.
224         for (uint256 i = 0; i < totalHashes; i++) {
225             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
226             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
227             hashes[i] = _hashPair(a, b);
228         }
229 
230         if (totalHashes > 0) {
231             return hashes[totalHashes - 1];
232         } else if (leavesLen > 0) {
233             return leaves[0];
234         } else {
235             return proof[0];
236         }
237     }
238 
239     /**
240      * @dev Calldata version of {processMultiProof}.
241      *
242      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
243      *
244      * _Available since v4.7._
245      */
246     function processMultiProofCalldata(
247         bytes32[] calldata proof,
248         bool[] calldata proofFlags,
249         bytes32[] memory leaves
250     ) internal pure returns (bytes32 merkleRoot) {
251         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
252         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
253         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
254         // the merkle tree.
255         uint256 leavesLen = leaves.length;
256         uint256 totalHashes = proofFlags.length;
257 
258         // Check proof validity.
259         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
260 
261         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
262         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
263         bytes32[] memory hashes = new bytes32[](totalHashes);
264         uint256 leafPos = 0;
265         uint256 hashPos = 0;
266         uint256 proofPos = 0;
267         // At each step, we compute the next hash using two values:
268         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
269         //   get the next hash.
270         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
271         //   `proof` array.
272         for (uint256 i = 0; i < totalHashes; i++) {
273             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
274             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
275             hashes[i] = _hashPair(a, b);
276         }
277 
278         if (totalHashes > 0) {
279             return hashes[totalHashes - 1];
280         } else if (leavesLen > 0) {
281             return leaves[0];
282         } else {
283             return proof[0];
284         }
285     }
286 
287     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
288         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
289     }
290 
291     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
292         /// @solidity memory-safe-assembly
293         assembly {
294             mstore(0x00, a)
295             mstore(0x20, b)
296             value := keccak256(0x00, 0x40)
297         }
298     }
299 }
300 
301 // File: @openzeppelin/contracts/utils/Context.sol
302 
303 
304 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 /**
309  * @dev Provides information about the current execution context, including the
310  * sender of the transaction and its data. While these are generally available
311  * via msg.sender and msg.data, they should not be accessed in such a direct
312  * manner, since when dealing with meta-transactions the account sending and
313  * paying for execution may not be the actual sender (as far as an application
314  * is concerned).
315  *
316  * This contract is only required for intermediate, library-like contracts.
317  */
318 abstract contract Context {
319     function _msgSender() internal view virtual returns (address) {
320         return msg.sender;
321     }
322 
323     function _msgData() internal view virtual returns (bytes calldata) {
324         return msg.data;
325     }
326 }
327 
328 // File: @openzeppelin/contracts/access/Ownable.sol
329 
330 
331 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 
336 /**
337  * @dev Contract module which provides a basic access control mechanism, where
338  * there is an account (an owner) that can be granted exclusive access to
339  * specific functions.
340  *
341  * By default, the owner account will be the one that deploys the contract. This
342  * can later be changed with {transferOwnership}.
343  *
344  * This module is used through inheritance. It will make available the modifier
345  * `onlyOwner`, which can be applied to your functions to restrict their use to
346  * the owner.
347  */
348 abstract contract Ownable is Context {
349     address private _owner;
350 
351     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
352 
353     /**
354      * @dev Initializes the contract setting the deployer as the initial owner.
355      */
356     constructor() {
357         _transferOwnership(_msgSender());
358     }
359 
360     /**
361      * @dev Throws if called by any account other than the owner.
362      */
363     modifier onlyOwner() {
364         _checkOwner();
365         _;
366     }
367 
368     /**
369      * @dev Returns the address of the current owner.
370      */
371     function owner() public view virtual returns (address) {
372         return _owner;
373     }
374 
375     /**
376      * @dev Throws if the sender is not the owner.
377      */
378     function _checkOwner() internal view virtual {
379         require(owner() == _msgSender(), "Ownable: caller is not the owner");
380     }
381 
382     /**
383      * @dev Leaves the contract without owner. It will not be possible to call
384      * `onlyOwner` functions anymore. Can only be called by the current owner.
385      *
386      * NOTE: Renouncing ownership will leave the contract without an owner,
387      * thereby removing any functionality that is only available to the owner.
388      */
389     function renounceOwnership() public virtual onlyOwner {
390         _transferOwnership(address(0));
391     }
392 
393     /**
394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
395      * Can only be called by the current owner.
396      */
397     function transferOwnership(address newOwner) public virtual onlyOwner {
398         require(newOwner != address(0), "Ownable: new owner is the zero address");
399         _transferOwnership(newOwner);
400     }
401 
402     /**
403      * @dev Transfers ownership of the contract to a new account (`newOwner`).
404      * Internal function without access restriction.
405      */
406     function _transferOwnership(address newOwner) internal virtual {
407         address oldOwner = _owner;
408         _owner = newOwner;
409         emit OwnershipTransferred(oldOwner, newOwner);
410     }
411 }
412 
413 // File: erc721a/contracts/IERC721A.sol
414 
415 
416 // ERC721A Contracts v4.2.3
417 // Creator: Chiru Labs
418 
419 pragma solidity ^0.8.4;
420 
421 /**
422  * @dev Interface of ERC721A.
423  */
424 interface IERC721A {
425     /**
426      * The caller must own the token or be an approved operator.
427      */
428     error ApprovalCallerNotOwnerNorApproved();
429 
430     /**
431      * The token does not exist.
432      */
433     error ApprovalQueryForNonexistentToken();
434 
435     /**
436      * Cannot query the balance for the zero address.
437      */
438     error BalanceQueryForZeroAddress();
439 
440     /**
441      * Cannot mint to the zero address.
442      */
443     error MintToZeroAddress();
444 
445     /**
446      * The quantity of tokens minted must be more than zero.
447      */
448     error MintZeroQuantity();
449 
450     /**
451      * The token does not exist.
452      */
453     error OwnerQueryForNonexistentToken();
454 
455     /**
456      * The caller must own the token or be an approved operator.
457      */
458     error TransferCallerNotOwnerNorApproved();
459 
460     /**
461      * The token must be owned by `from`.
462      */
463     error TransferFromIncorrectOwner();
464 
465     /**
466      * Cannot safely transfer to a contract that does not implement the
467      * ERC721Receiver interface.
468      */
469     error TransferToNonERC721ReceiverImplementer();
470 
471     /**
472      * Cannot transfer to the zero address.
473      */
474     error TransferToZeroAddress();
475 
476     /**
477      * The token does not exist.
478      */
479     error URIQueryForNonexistentToken();
480 
481     /**
482      * The `quantity` minted with ERC2309 exceeds the safety limit.
483      */
484     error MintERC2309QuantityExceedsLimit();
485 
486     /**
487      * The `extraData` cannot be set on an unintialized ownership slot.
488      */
489     error OwnershipNotInitializedForExtraData();
490 
491     // =============================================================
492     //                            STRUCTS
493     // =============================================================
494 
495     struct TokenOwnership {
496         // The address of the owner.
497         address addr;
498         // Stores the start time of ownership with minimal overhead for tokenomics.
499         uint64 startTimestamp;
500         // Whether the token has been burned.
501         bool burned;
502         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
503         uint24 extraData;
504     }
505 
506     // =============================================================
507     //                         TOKEN COUNTERS
508     // =============================================================
509 
510     /**
511      * @dev Returns the total number of tokens in existence.
512      * Burned tokens will reduce the count.
513      * To get the total number of tokens minted, please see {_totalMinted}.
514      */
515     function totalSupply() external view returns (uint256);
516 
517     // =============================================================
518     //                            IERC165
519     // =============================================================
520 
521     /**
522      * @dev Returns true if this contract implements the interface defined by
523      * `interfaceId`. See the corresponding
524      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
525      * to learn more about how these ids are created.
526      *
527      * This function call must use less than 30000 gas.
528      */
529     function supportsInterface(bytes4 interfaceId) external view returns (bool);
530 
531     // =============================================================
532     //                            IERC721
533     // =============================================================
534 
535     /**
536      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
537      */
538     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
539 
540     /**
541      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
542      */
543     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
544 
545     /**
546      * @dev Emitted when `owner` enables or disables
547      * (`approved`) `operator` to manage all of its assets.
548      */
549     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
550 
551     /**
552      * @dev Returns the number of tokens in `owner`'s account.
553      */
554     function balanceOf(address owner) external view returns (uint256 balance);
555 
556     /**
557      * @dev Returns the owner of the `tokenId` token.
558      *
559      * Requirements:
560      *
561      * - `tokenId` must exist.
562      */
563     function ownerOf(uint256 tokenId) external view returns (address owner);
564 
565     /**
566      * @dev Safely transfers `tokenId` token from `from` to `to`,
567      * checking first that contract recipients are aware of the ERC721 protocol
568      * to prevent tokens from being forever locked.
569      *
570      * Requirements:
571      *
572      * - `from` cannot be the zero address.
573      * - `to` cannot be the zero address.
574      * - `tokenId` token must exist and be owned by `from`.
575      * - If the caller is not `from`, it must be have been allowed to move
576      * this token by either {approve} or {setApprovalForAll}.
577      * - If `to` refers to a smart contract, it must implement
578      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
579      *
580      * Emits a {Transfer} event.
581      */
582     function safeTransferFrom(
583         address from,
584         address to,
585         uint256 tokenId,
586         bytes calldata data
587     ) external payable;
588 
589     /**
590      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
591      */
592     function safeTransferFrom(
593         address from,
594         address to,
595         uint256 tokenId
596     ) external payable;
597 
598     /**
599      * @dev Transfers `tokenId` from `from` to `to`.
600      *
601      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
602      * whenever possible.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must be owned by `from`.
609      * - If the caller is not `from`, it must be approved to move this token
610      * by either {approve} or {setApprovalForAll}.
611      *
612      * Emits a {Transfer} event.
613      */
614     function transferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external payable;
619 
620     /**
621      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
622      * The approval is cleared when the token is transferred.
623      *
624      * Only a single account can be approved at a time, so approving the
625      * zero address clears previous approvals.
626      *
627      * Requirements:
628      *
629      * - The caller must own the token or be an approved operator.
630      * - `tokenId` must exist.
631      *
632      * Emits an {Approval} event.
633      */
634     function approve(address to, uint256 tokenId) external payable;
635 
636     /**
637      * @dev Approve or remove `operator` as an operator for the caller.
638      * Operators can call {transferFrom} or {safeTransferFrom}
639      * for any token owned by the caller.
640      *
641      * Requirements:
642      *
643      * - The `operator` cannot be the caller.
644      *
645      * Emits an {ApprovalForAll} event.
646      */
647     function setApprovalForAll(address operator, bool _approved) external;
648 
649     /**
650      * @dev Returns the account approved for `tokenId` token.
651      *
652      * Requirements:
653      *
654      * - `tokenId` must exist.
655      */
656     function getApproved(uint256 tokenId) external view returns (address operator);
657 
658     /**
659      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
660      *
661      * See {setApprovalForAll}.
662      */
663     function isApprovedForAll(address owner, address operator) external view returns (bool);
664 
665     // =============================================================
666     //                        IERC721Metadata
667     // =============================================================
668 
669     /**
670      * @dev Returns the token collection name.
671      */
672     function name() external view returns (string memory);
673 
674     /**
675      * @dev Returns the token collection symbol.
676      */
677     function symbol() external view returns (string memory);
678 
679     /**
680      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
681      */
682     function tokenURI(uint256 tokenId) external view returns (string memory);
683 
684     // =============================================================
685     //                           IERC2309
686     // =============================================================
687 
688     /**
689      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
690      * (inclusive) is transferred from `from` to `to`, as defined in the
691      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
692      *
693      * See {_mintERC2309} for more details.
694      */
695     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
696 }
697 
698 // File: erc721a/contracts/ERC721A.sol
699 
700 
701 // ERC721A Contracts v4.2.3
702 // Creator: Chiru Labs
703 
704 pragma solidity ^0.8.4;
705 
706 
707 /**
708  * @dev Interface of ERC721 token receiver.
709  */
710 interface ERC721A__IERC721Receiver {
711     function onERC721Received(
712         address operator,
713         address from,
714         uint256 tokenId,
715         bytes calldata data
716     ) external returns (bytes4);
717 }
718 
719 /**
720  * @title ERC721A
721  *
722  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
723  * Non-Fungible Token Standard, including the Metadata extension.
724  * Optimized for lower gas during batch mints.
725  *
726  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
727  * starting from `_startTokenId()`.
728  *
729  * Assumptions:
730  *
731  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
732  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
733  */
734 contract ERC721A is IERC721A {
735     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
736     struct TokenApprovalRef {
737         address value;
738     }
739 
740     // =============================================================
741     //                           CONSTANTS
742     // =============================================================
743 
744     // Mask of an entry in packed address data.
745     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
746 
747     // The bit position of `numberMinted` in packed address data.
748     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
749 
750     // The bit position of `numberBurned` in packed address data.
751     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
752 
753     // The bit position of `aux` in packed address data.
754     uint256 private constant _BITPOS_AUX = 192;
755 
756     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
757     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
758 
759     // The bit position of `startTimestamp` in packed ownership.
760     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
761 
762     // The bit mask of the `burned` bit in packed ownership.
763     uint256 private constant _BITMASK_BURNED = 1 << 224;
764 
765     // The bit position of the `nextInitialized` bit in packed ownership.
766     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
767 
768     // The bit mask of the `nextInitialized` bit in packed ownership.
769     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
770 
771     // The bit position of `extraData` in packed ownership.
772     uint256 private constant _BITPOS_EXTRA_DATA = 232;
773 
774     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
775     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
776 
777     // The mask of the lower 160 bits for addresses.
778     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
779 
780     // The maximum `quantity` that can be minted with {_mintERC2309}.
781     // This limit is to prevent overflows on the address data entries.
782     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
783     // is required to cause an overflow, which is unrealistic.
784     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
785 
786     // The `Transfer` event signature is given by:
787     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
788     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
789         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
790 
791     // =============================================================
792     //                            STORAGE
793     // =============================================================
794 
795     // The next token ID to be minted.
796     uint256 private _currentIndex;
797 
798     // The number of tokens burned.
799     uint256 private _burnCounter;
800 
801     // Token name
802     string private _name;
803 
804     // Token symbol
805     string private _symbol;
806 
807     // Mapping from token ID to ownership details
808     // An empty struct value does not necessarily mean the token is unowned.
809     // See {_packedOwnershipOf} implementation for details.
810     //
811     // Bits Layout:
812     // - [0..159]   `addr`
813     // - [160..223] `startTimestamp`
814     // - [224]      `burned`
815     // - [225]      `nextInitialized`
816     // - [232..255] `extraData`
817     mapping(uint256 => uint256) private _packedOwnerships;
818 
819     // Mapping owner address to address data.
820     //
821     // Bits Layout:
822     // - [0..63]    `balance`
823     // - [64..127]  `numberMinted`
824     // - [128..191] `numberBurned`
825     // - [192..255] `aux`
826     mapping(address => uint256) private _packedAddressData;
827 
828     // Mapping from token ID to approved address.
829     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
830 
831     // Mapping from owner to operator approvals
832     mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834     // =============================================================
835     //                          CONSTRUCTOR
836     // =============================================================
837 
838     constructor(string memory name_, string memory symbol_) {
839         _name = name_;
840         _symbol = symbol_;
841         _currentIndex = _startTokenId();
842     }
843 
844     // =============================================================
845     //                   TOKEN COUNTING OPERATIONS
846     // =============================================================
847 
848     /**
849      * @dev Returns the starting token ID.
850      * To change the starting token ID, please override this function.
851      */
852     function _startTokenId() internal view virtual returns (uint256) {
853         return 0;
854     }
855 
856     /**
857      * @dev Returns the next token ID to be minted.
858      */
859     function _nextTokenId() internal view virtual returns (uint256) {
860         return _currentIndex;
861     }
862 
863     /**
864      * @dev Returns the total number of tokens in existence.
865      * Burned tokens will reduce the count.
866      * To get the total number of tokens minted, please see {_totalMinted}.
867      */
868     function totalSupply() public view virtual override returns (uint256) {
869         // Counter underflow is impossible as _burnCounter cannot be incremented
870         // more than `_currentIndex - _startTokenId()` times.
871         unchecked {
872             return _currentIndex - _burnCounter - _startTokenId();
873         }
874     }
875 
876     /**
877      * @dev Returns the total amount of tokens minted in the contract.
878      */
879     function _totalMinted() internal view virtual returns (uint256) {
880         // Counter underflow is impossible as `_currentIndex` does not decrement,
881         // and it is initialized to `_startTokenId()`.
882         unchecked {
883             return _currentIndex - _startTokenId();
884         }
885     }
886 
887     /**
888      * @dev Returns the total number of tokens burned.
889      */
890     function _totalBurned() internal view virtual returns (uint256) {
891         return _burnCounter;
892     }
893 
894     // =============================================================
895     //                    ADDRESS DATA OPERATIONS
896     // =============================================================
897 
898     /**
899      * @dev Returns the number of tokens in `owner`'s account.
900      */
901     function balanceOf(address owner) public view virtual override returns (uint256) {
902         if (owner == address(0)) revert BalanceQueryForZeroAddress();
903         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
904     }
905 
906     /**
907      * Returns the number of tokens minted by `owner`.
908      */
909     function _numberMinted(address owner) internal view returns (uint256) {
910         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
911     }
912 
913     /**
914      * Returns the number of tokens burned by or on behalf of `owner`.
915      */
916     function _numberBurned(address owner) internal view returns (uint256) {
917         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
918     }
919 
920     /**
921      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
922      */
923     function _getAux(address owner) internal view returns (uint64) {
924         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
925     }
926 
927     /**
928      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
929      * If there are multiple variables, please pack them into a uint64.
930      */
931     function _setAux(address owner, uint64 aux) internal virtual {
932         uint256 packed = _packedAddressData[owner];
933         uint256 auxCasted;
934         // Cast `aux` with assembly to avoid redundant masking.
935         assembly {
936             auxCasted := aux
937         }
938         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
939         _packedAddressData[owner] = packed;
940     }
941 
942     // =============================================================
943     //                            IERC165
944     // =============================================================
945 
946     /**
947      * @dev Returns true if this contract implements the interface defined by
948      * `interfaceId`. See the corresponding
949      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
950      * to learn more about how these ids are created.
951      *
952      * This function call must use less than 30000 gas.
953      */
954     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
955         // The interface IDs are constants representing the first 4 bytes
956         // of the XOR of all function selectors in the interface.
957         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
958         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
959         return
960             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
961             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
962             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
963     }
964 
965     // =============================================================
966     //                        IERC721Metadata
967     // =============================================================
968 
969     /**
970      * @dev Returns the token collection name.
971      */
972     function name() public view virtual override returns (string memory) {
973         return _name;
974     }
975 
976     /**
977      * @dev Returns the token collection symbol.
978      */
979     function symbol() public view virtual override returns (string memory) {
980         return _symbol;
981     }
982 
983     /**
984      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
985      */
986     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
987         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
988 
989         string memory baseURI = _baseURI();
990         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
991     }
992 
993     /**
994      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
995      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
996      * by default, it can be overridden in child contracts.
997      */
998     function _baseURI() internal view virtual returns (string memory) {
999         return '';
1000     }
1001 
1002     // =============================================================
1003     //                     OWNERSHIPS OPERATIONS
1004     // =============================================================
1005 
1006     /**
1007      * @dev Returns the owner of the `tokenId` token.
1008      *
1009      * Requirements:
1010      *
1011      * - `tokenId` must exist.
1012      */
1013     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1014         return address(uint160(_packedOwnershipOf(tokenId)));
1015     }
1016 
1017     /**
1018      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1019      * It gradually moves to O(1) as tokens get transferred around over time.
1020      */
1021     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1022         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1023     }
1024 
1025     /**
1026      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1027      */
1028     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1029         return _unpackedOwnership(_packedOwnerships[index]);
1030     }
1031 
1032     /**
1033      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1034      */
1035     function _initializeOwnershipAt(uint256 index) internal virtual {
1036         if (_packedOwnerships[index] == 0) {
1037             _packedOwnerships[index] = _packedOwnershipOf(index);
1038         }
1039     }
1040 
1041     /**
1042      * Returns the packed ownership data of `tokenId`.
1043      */
1044     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1045         uint256 curr = tokenId;
1046 
1047         unchecked {
1048             if (_startTokenId() <= curr)
1049                 if (curr < _currentIndex) {
1050                     uint256 packed = _packedOwnerships[curr];
1051                     // If not burned.
1052                     if (packed & _BITMASK_BURNED == 0) {
1053                         // Invariant:
1054                         // There will always be an initialized ownership slot
1055                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1056                         // before an unintialized ownership slot
1057                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1058                         // Hence, `curr` will not underflow.
1059                         //
1060                         // We can directly compare the packed value.
1061                         // If the address is zero, packed will be zero.
1062                         while (packed == 0) {
1063                             packed = _packedOwnerships[--curr];
1064                         }
1065                         return packed;
1066                     }
1067                 }
1068         }
1069         revert OwnerQueryForNonexistentToken();
1070     }
1071 
1072     /**
1073      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1074      */
1075     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1076         ownership.addr = address(uint160(packed));
1077         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1078         ownership.burned = packed & _BITMASK_BURNED != 0;
1079         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1080     }
1081 
1082     /**
1083      * @dev Packs ownership data into a single uint256.
1084      */
1085     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1086         assembly {
1087             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1088             owner := and(owner, _BITMASK_ADDRESS)
1089             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1090             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1091         }
1092     }
1093 
1094     /**
1095      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1096      */
1097     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1098         // For branchless setting of the `nextInitialized` flag.
1099         assembly {
1100             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1101             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1102         }
1103     }
1104 
1105     // =============================================================
1106     //                      APPROVAL OPERATIONS
1107     // =============================================================
1108 
1109     /**
1110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1111      * The approval is cleared when the token is transferred.
1112      *
1113      * Only a single account can be approved at a time, so approving the
1114      * zero address clears previous approvals.
1115      *
1116      * Requirements:
1117      *
1118      * - The caller must own the token or be an approved operator.
1119      * - `tokenId` must exist.
1120      *
1121      * Emits an {Approval} event.
1122      */
1123     function approve(address to, uint256 tokenId) public payable virtual override {
1124         address owner = ownerOf(tokenId);
1125 
1126         if (_msgSenderERC721A() != owner)
1127             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1128                 revert ApprovalCallerNotOwnerNorApproved();
1129             }
1130 
1131         _tokenApprovals[tokenId].value = to;
1132         emit Approval(owner, to, tokenId);
1133     }
1134 
1135     /**
1136      * @dev Returns the account approved for `tokenId` token.
1137      *
1138      * Requirements:
1139      *
1140      * - `tokenId` must exist.
1141      */
1142     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1143         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1144 
1145         return _tokenApprovals[tokenId].value;
1146     }
1147 
1148     /**
1149      * @dev Approve or remove `operator` as an operator for the caller.
1150      * Operators can call {transferFrom} or {safeTransferFrom}
1151      * for any token owned by the caller.
1152      *
1153      * Requirements:
1154      *
1155      * - The `operator` cannot be the caller.
1156      *
1157      * Emits an {ApprovalForAll} event.
1158      */
1159     function setApprovalForAll(address operator, bool approved) public virtual override {
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
1214         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
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
1242     ) public payable virtual override {
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
1308     ) public payable virtual override {
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
1332     ) public payable virtual override {
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
1462             // The duplicated `log4` removes an extra check and reduces stack juggling.
1463             // The assembly, together with the surrounding Solidity code, have been
1464             // delicately arranged to nudge the compiler into producing optimized opcodes.
1465             assembly {
1466                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1467                 toMasked := and(to, _BITMASK_ADDRESS)
1468                 // Emit the `Transfer` event.
1469                 log4(
1470                     0, // Start of data (0, since no data).
1471                     0, // End of data (0, since no data).
1472                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1473                     0, // `address(0)`.
1474                     toMasked, // `to`.
1475                     startTokenId // `tokenId`.
1476                 )
1477 
1478                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1479                 // that overflows uint256 will make the loop run out of gas.
1480                 // The compiler will optimize the `iszero` away for performance.
1481                 for {
1482                     let tokenId := add(startTokenId, 1)
1483                 } iszero(eq(tokenId, end)) {
1484                     tokenId := add(tokenId, 1)
1485                 } {
1486                     // Emit the `Transfer` event. Similar to above.
1487                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1488                 }
1489             }
1490             if (toMasked == 0) revert MintToZeroAddress();
1491 
1492             _currentIndex = end;
1493         }
1494         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1495     }
1496 
1497     /**
1498      * @dev Mints `quantity` tokens and transfers them to `to`.
1499      *
1500      * This function is intended for efficient minting only during contract creation.
1501      *
1502      * It emits only one {ConsecutiveTransfer} as defined in
1503      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1504      * instead of a sequence of {Transfer} event(s).
1505      *
1506      * Calling this function outside of contract creation WILL make your contract
1507      * non-compliant with the ERC721 standard.
1508      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1509      * {ConsecutiveTransfer} event is only permissible during contract creation.
1510      *
1511      * Requirements:
1512      *
1513      * - `to` cannot be the zero address.
1514      * - `quantity` must be greater than 0.
1515      *
1516      * Emits a {ConsecutiveTransfer} event.
1517      */
1518     function _mintERC2309(address to, uint256 quantity) internal virtual {
1519         uint256 startTokenId = _currentIndex;
1520         if (to == address(0)) revert MintToZeroAddress();
1521         if (quantity == 0) revert MintZeroQuantity();
1522         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1523 
1524         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1525 
1526         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1527         unchecked {
1528             // Updates:
1529             // - `balance += quantity`.
1530             // - `numberMinted += quantity`.
1531             //
1532             // We can directly add to the `balance` and `numberMinted`.
1533             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1534 
1535             // Updates:
1536             // - `address` to the owner.
1537             // - `startTimestamp` to the timestamp of minting.
1538             // - `burned` to `false`.
1539             // - `nextInitialized` to `quantity == 1`.
1540             _packedOwnerships[startTokenId] = _packOwnershipData(
1541                 to,
1542                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1543             );
1544 
1545             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1546 
1547             _currentIndex = startTokenId + quantity;
1548         }
1549         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1550     }
1551 
1552     /**
1553      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1554      *
1555      * Requirements:
1556      *
1557      * - If `to` refers to a smart contract, it must implement
1558      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1559      * - `quantity` must be greater than 0.
1560      *
1561      * See {_mint}.
1562      *
1563      * Emits a {Transfer} event for each mint.
1564      */
1565     function _safeMint(
1566         address to,
1567         uint256 quantity,
1568         bytes memory _data
1569     ) internal virtual {
1570         _mint(to, quantity);
1571 
1572         unchecked {
1573             if (to.code.length != 0) {
1574                 uint256 end = _currentIndex;
1575                 uint256 index = end - quantity;
1576                 do {
1577                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1578                         revert TransferToNonERC721ReceiverImplementer();
1579                     }
1580                 } while (index < end);
1581                 // Reentrancy protection.
1582                 if (_currentIndex != end) revert();
1583             }
1584         }
1585     }
1586 
1587     /**
1588      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1589      */
1590     function _safeMint(address to, uint256 quantity) internal virtual {
1591         _safeMint(to, quantity, '');
1592     }
1593 
1594     // =============================================================
1595     //                        BURN OPERATIONS
1596     // =============================================================
1597 
1598     /**
1599      * @dev Equivalent to `_burn(tokenId, false)`.
1600      */
1601     function _burn(uint256 tokenId) internal virtual {
1602         _burn(tokenId, false);
1603     }
1604 
1605     /**
1606      * @dev Destroys `tokenId`.
1607      * The approval is cleared when the token is burned.
1608      *
1609      * Requirements:
1610      *
1611      * - `tokenId` must exist.
1612      *
1613      * Emits a {Transfer} event.
1614      */
1615     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1616         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1617 
1618         address from = address(uint160(prevOwnershipPacked));
1619 
1620         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1621 
1622         if (approvalCheck) {
1623             // The nested ifs save around 20+ gas over a compound boolean condition.
1624             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1625                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1626         }
1627 
1628         _beforeTokenTransfers(from, address(0), tokenId, 1);
1629 
1630         // Clear approvals from the previous owner.
1631         assembly {
1632             if approvedAddress {
1633                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1634                 sstore(approvedAddressSlot, 0)
1635             }
1636         }
1637 
1638         // Underflow of the sender's balance is impossible because we check for
1639         // ownership above and the recipient's balance can't realistically overflow.
1640         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1641         unchecked {
1642             // Updates:
1643             // - `balance -= 1`.
1644             // - `numberBurned += 1`.
1645             //
1646             // We can directly decrement the balance, and increment the number burned.
1647             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1648             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1649 
1650             // Updates:
1651             // - `address` to the last owner.
1652             // - `startTimestamp` to the timestamp of burning.
1653             // - `burned` to `true`.
1654             // - `nextInitialized` to `true`.
1655             _packedOwnerships[tokenId] = _packOwnershipData(
1656                 from,
1657                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1658             );
1659 
1660             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1661             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1662                 uint256 nextTokenId = tokenId + 1;
1663                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1664                 if (_packedOwnerships[nextTokenId] == 0) {
1665                     // If the next slot is within bounds.
1666                     if (nextTokenId != _currentIndex) {
1667                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1668                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1669                     }
1670                 }
1671             }
1672         }
1673 
1674         emit Transfer(from, address(0), tokenId);
1675         _afterTokenTransfers(from, address(0), tokenId, 1);
1676 
1677         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1678         unchecked {
1679             _burnCounter++;
1680         }
1681     }
1682 
1683     // =============================================================
1684     //                     EXTRA DATA OPERATIONS
1685     // =============================================================
1686 
1687     /**
1688      * @dev Directly sets the extra data for the ownership data `index`.
1689      */
1690     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1691         uint256 packed = _packedOwnerships[index];
1692         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1693         uint256 extraDataCasted;
1694         // Cast `extraData` with assembly to avoid redundant masking.
1695         assembly {
1696             extraDataCasted := extraData
1697         }
1698         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1699         _packedOwnerships[index] = packed;
1700     }
1701 
1702     /**
1703      * @dev Called during each token transfer to set the 24bit `extraData` field.
1704      * Intended to be overridden by the cosumer contract.
1705      *
1706      * `previousExtraData` - the value of `extraData` before transfer.
1707      *
1708      * Calling conditions:
1709      *
1710      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1711      * transferred to `to`.
1712      * - When `from` is zero, `tokenId` will be minted for `to`.
1713      * - When `to` is zero, `tokenId` will be burned by `from`.
1714      * - `from` and `to` are never both zero.
1715      */
1716     function _extraData(
1717         address from,
1718         address to,
1719         uint24 previousExtraData
1720     ) internal view virtual returns (uint24) {}
1721 
1722     /**
1723      * @dev Returns the next extra data for the packed ownership data.
1724      * The returned result is shifted into position.
1725      */
1726     function _nextExtraData(
1727         address from,
1728         address to,
1729         uint256 prevOwnershipPacked
1730     ) private view returns (uint256) {
1731         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1732         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1733     }
1734 
1735     // =============================================================
1736     //                       OTHER OPERATIONS
1737     // =============================================================
1738 
1739     /**
1740      * @dev Returns the message sender (defaults to `msg.sender`).
1741      *
1742      * If you are writing GSN compatible contracts, you need to override this function.
1743      */
1744     function _msgSenderERC721A() internal view virtual returns (address) {
1745         return msg.sender;
1746     }
1747 
1748     /**
1749      * @dev Converts a uint256 to its ASCII string decimal representation.
1750      */
1751     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1752         assembly {
1753             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1754             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1755             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1756             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1757             let m := add(mload(0x40), 0xa0)
1758             // Update the free memory pointer to allocate.
1759             mstore(0x40, m)
1760             // Assign the `str` to the end.
1761             str := sub(m, 0x20)
1762             // Zeroize the slot after the string.
1763             mstore(str, 0)
1764 
1765             // Cache the end of the memory to calculate the length later.
1766             let end := str
1767 
1768             // We write the string from rightmost digit to leftmost digit.
1769             // The following is essentially a do-while loop that also handles the zero case.
1770             // prettier-ignore
1771             for { let temp := value } 1 {} {
1772                 str := sub(str, 1)
1773                 // Write the character to the pointer.
1774                 // The ASCII index of the '0' character is 48.
1775                 mstore8(str, add(48, mod(temp, 10)))
1776                 // Keep dividing `temp` until zero.
1777                 temp := div(temp, 10)
1778                 // prettier-ignore
1779                 if iszero(temp) { break }
1780             }
1781 
1782             let length := sub(end, str)
1783             // Move the pointer 32 bytes leftwards to make room for the length.
1784             str := sub(str, 0x20)
1785             // Store the length.
1786             mstore(str, length)
1787         }
1788     }
1789 }
1790 
1791 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1792 
1793 
1794 // ERC721A Contracts v4.2.3
1795 // Creator: Chiru Labs
1796 
1797 pragma solidity ^0.8.4;
1798 
1799 
1800 /**
1801  * @dev Interface of ERC721AQueryable.
1802  */
1803 interface IERC721AQueryable is IERC721A {
1804     /**
1805      * Invalid query range (`start` >= `stop`).
1806      */
1807     error InvalidQueryRange();
1808 
1809     /**
1810      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1811      *
1812      * If the `tokenId` is out of bounds:
1813      *
1814      * - `addr = address(0)`
1815      * - `startTimestamp = 0`
1816      * - `burned = false`
1817      * - `extraData = 0`
1818      *
1819      * If the `tokenId` is burned:
1820      *
1821      * - `addr = <Address of owner before token was burned>`
1822      * - `startTimestamp = <Timestamp when token was burned>`
1823      * - `burned = true`
1824      * - `extraData = <Extra data when token was burned>`
1825      *
1826      * Otherwise:
1827      *
1828      * - `addr = <Address of owner>`
1829      * - `startTimestamp = <Timestamp of start of ownership>`
1830      * - `burned = false`
1831      * - `extraData = <Extra data at start of ownership>`
1832      */
1833     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1834 
1835     /**
1836      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1837      * See {ERC721AQueryable-explicitOwnershipOf}
1838      */
1839     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1840 
1841     /**
1842      * @dev Returns an array of token IDs owned by `owner`,
1843      * in the range [`start`, `stop`)
1844      * (i.e. `start <= tokenId < stop`).
1845      *
1846      * This function allows for tokens to be queried if the collection
1847      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1848      *
1849      * Requirements:
1850      *
1851      * - `start < stop`
1852      */
1853     function tokensOfOwnerIn(
1854         address owner,
1855         uint256 start,
1856         uint256 stop
1857     ) external view returns (uint256[] memory);
1858 
1859     /**
1860      * @dev Returns an array of token IDs owned by `owner`.
1861      *
1862      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1863      * It is meant to be called off-chain.
1864      *
1865      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1866      * multiple smaller scans if the collection is large enough to cause
1867      * an out-of-gas error (10K collections should be fine).
1868      */
1869     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1870 }
1871 
1872 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1873 
1874 
1875 // ERC721A Contracts v4.2.3
1876 // Creator: Chiru Labs
1877 
1878 pragma solidity ^0.8.4;
1879 
1880 
1881 
1882 /**
1883  * @title ERC721AQueryable.
1884  *
1885  * @dev ERC721A subclass with convenience query functions.
1886  */
1887 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1888     /**
1889      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1890      *
1891      * If the `tokenId` is out of bounds:
1892      *
1893      * - `addr = address(0)`
1894      * - `startTimestamp = 0`
1895      * - `burned = false`
1896      * - `extraData = 0`
1897      *
1898      * If the `tokenId` is burned:
1899      *
1900      * - `addr = <Address of owner before token was burned>`
1901      * - `startTimestamp = <Timestamp when token was burned>`
1902      * - `burned = true`
1903      * - `extraData = <Extra data when token was burned>`
1904      *
1905      * Otherwise:
1906      *
1907      * - `addr = <Address of owner>`
1908      * - `startTimestamp = <Timestamp of start of ownership>`
1909      * - `burned = false`
1910      * - `extraData = <Extra data at start of ownership>`
1911      */
1912     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1913         TokenOwnership memory ownership;
1914         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1915             return ownership;
1916         }
1917         ownership = _ownershipAt(tokenId);
1918         if (ownership.burned) {
1919             return ownership;
1920         }
1921         return _ownershipOf(tokenId);
1922     }
1923 
1924     /**
1925      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1926      * See {ERC721AQueryable-explicitOwnershipOf}
1927      */
1928     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1929         external
1930         view
1931         virtual
1932         override
1933         returns (TokenOwnership[] memory)
1934     {
1935         unchecked {
1936             uint256 tokenIdsLength = tokenIds.length;
1937             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1938             for (uint256 i; i != tokenIdsLength; ++i) {
1939                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1940             }
1941             return ownerships;
1942         }
1943     }
1944 
1945     /**
1946      * @dev Returns an array of token IDs owned by `owner`,
1947      * in the range [`start`, `stop`)
1948      * (i.e. `start <= tokenId < stop`).
1949      *
1950      * This function allows for tokens to be queried if the collection
1951      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1952      *
1953      * Requirements:
1954      *
1955      * - `start < stop`
1956      */
1957     function tokensOfOwnerIn(
1958         address owner,
1959         uint256 start,
1960         uint256 stop
1961     ) external view virtual override returns (uint256[] memory) {
1962         unchecked {
1963             if (start >= stop) revert InvalidQueryRange();
1964             uint256 tokenIdsIdx;
1965             uint256 stopLimit = _nextTokenId();
1966             // Set `start = max(start, _startTokenId())`.
1967             if (start < _startTokenId()) {
1968                 start = _startTokenId();
1969             }
1970             // Set `stop = min(stop, stopLimit)`.
1971             if (stop > stopLimit) {
1972                 stop = stopLimit;
1973             }
1974             uint256 tokenIdsMaxLength = balanceOf(owner);
1975             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1976             // to cater for cases where `balanceOf(owner)` is too big.
1977             if (start < stop) {
1978                 uint256 rangeLength = stop - start;
1979                 if (rangeLength < tokenIdsMaxLength) {
1980                     tokenIdsMaxLength = rangeLength;
1981                 }
1982             } else {
1983                 tokenIdsMaxLength = 0;
1984             }
1985             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1986             if (tokenIdsMaxLength == 0) {
1987                 return tokenIds;
1988             }
1989             // We need to call `explicitOwnershipOf(start)`,
1990             // because the slot at `start` may not be initialized.
1991             TokenOwnership memory ownership = explicitOwnershipOf(start);
1992             address currOwnershipAddr;
1993             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1994             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1995             if (!ownership.burned) {
1996                 currOwnershipAddr = ownership.addr;
1997             }
1998             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1999                 ownership = _ownershipAt(i);
2000                 if (ownership.burned) {
2001                     continue;
2002                 }
2003                 if (ownership.addr != address(0)) {
2004                     currOwnershipAddr = ownership.addr;
2005                 }
2006                 if (currOwnershipAddr == owner) {
2007                     tokenIds[tokenIdsIdx++] = i;
2008                 }
2009             }
2010             // Downsize the array to fit.
2011             assembly {
2012                 mstore(tokenIds, tokenIdsIdx)
2013             }
2014             return tokenIds;
2015         }
2016     }
2017 
2018     /**
2019      * @dev Returns an array of token IDs owned by `owner`.
2020      *
2021      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2022      * It is meant to be called off-chain.
2023      *
2024      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2025      * multiple smaller scans if the collection is large enough to cause
2026      * an out-of-gas error (10K collections should be fine).
2027      */
2028     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2029         unchecked {
2030             uint256 tokenIdsIdx;
2031             address currOwnershipAddr;
2032             uint256 tokenIdsLength = balanceOf(owner);
2033             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2034             TokenOwnership memory ownership;
2035             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2036                 ownership = _ownershipAt(i);
2037                 if (ownership.burned) {
2038                     continue;
2039                 }
2040                 if (ownership.addr != address(0)) {
2041                     currOwnershipAddr = ownership.addr;
2042                 }
2043                 if (currOwnershipAddr == owner) {
2044                     tokenIds[tokenIdsIdx++] = i;
2045                 }
2046             }
2047             return tokenIds;
2048         }
2049     }
2050 }
2051 
2052 
2053 pragma solidity >=0.7.0 <0.9.0;
2054 
2055 /******************************************************************************************* /
2056 *   ███████████                   ██████████                                               *
2057 * ░░███░░░░░░█                  ░░███░░░░███                                               *
2058 *  ░███   █ ░   ██████   ███████ ░███   ░░███ ████████   ██████  ████████   █████          *
2059 *  ░███████    ███░░███ ███░░███ ░███    ░███░░███░░███ ███░░███░░███░░███ ███░░           *
2060 *  ░███░░░█   ░███ ░███░███ ░███ ░███    ░███ ░███ ░░░ ░███ ░███ ░███ ░███░░█████          *
2061 *  ░███  ░    ░███ ░███░███ ░███ ░███    ███  ░███     ░███ ░███ ░███ ░███ ░░░░███         *
2062 *  █████      ░░██████ ░░███████ ██████████   █████    ░░██████  ░███████  ██████          *
2063 * ░░░░░        ░░░░░░   ░░░░░███░░░░░░░░░░   ░░░░░      ░░░░░░   ░███░░░  ░░░░░░           *
2064 *                       ███ ░███                                 ░███                      *
2065 *                      ░░██████                                  █████                     *
2066 *                       ░░░░░░                                  ░░░░░                      *
2067 ******************************************************************************************** /                                                        *
2068 */
2069 
2070 contract FogDrop is ERC721AQueryable, Ownable, ReentrancyGuard {
2071     string public baseTokenURI = "";
2072 
2073     string public uriSuffix = "";
2074 
2075     bytes32 public merkleRoot;
2076 
2077     uint256 public cost;
2078 
2079     uint256 public maxSupply;
2080 
2081     uint256 public maxMintAmountPerTx;
2082 
2083     uint256 public maxMintAmountPreOwner;
2084 
2085     bool public mintPaused = true;
2086     bool public whitelistMintEnabled = false;
2087 
2088     constructor(
2089         string memory _name,
2090         string memory _symbol,
2091         uint256 _maxPreTx,
2092         uint256 _maxSupply,
2093         uint256 _maxPreOwner,
2094         uint256 _cost,
2095         string memory _baseUri
2096     ) ERC721A(_name, _symbol) {
2097         maxMintAmountPerTx = _maxPreTx;
2098         maxMintAmountPreOwner = _maxPreOwner;
2099         maxSupply = _maxSupply;
2100         cost = _cost;
2101         baseTokenURI = _baseUri;
2102     }
2103 
2104     /**
2105      * @dev check the conditions are valid
2106      */
2107     modifier _check_mint_compliance(uint256 _mintAmount) {
2108         require(_msgSender().code.length == 0, "invalid addres");
2109         require(
2110             _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
2111             "Invalid mint amount!"
2112         );
2113         require(
2114             ownerMintAmount(_msgSender()) + _mintAmount <=
2115                 maxMintAmountPreOwner,
2116             "mint amount limited"
2117         );
2118         require(
2119             totalSupply() + _mintAmount <= maxSupply,
2120             "Max supply exceeded!"
2121         );
2122         _;
2123     }
2124 
2125     /**
2126      * @dev check mint balance
2127      */
2128     modifier _check_mint_balance(uint256 _mintAmount) {
2129         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
2130         _;
2131     }
2132 
2133     /**
2134      * @dev return someone mint amount
2135      */
2136     function ownerMintAmount(address owner) public view returns (uint256) {
2137         return _numberMinted(owner);
2138     }
2139 
2140     /**
2141      * @dev whitelist mint NFTs
2142      */
2143     function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof)
2144         public
2145         payable
2146         _check_mint_compliance(_mintAmount)
2147         _check_mint_balance(_mintAmount)
2148     {
2149         // Verify whitelist requirements
2150         require(whitelistMintEnabled, "The whitelist sale is not enabled!");
2151         require(
2152             numberWhitelistMinted(_msgSender()) == 0,
2153             "Address already claimed!"
2154         );
2155         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2156         require(
2157             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
2158             "Invalid proof!"
2159         );
2160 
2161         _setAux(_msgSender(), _getAux(_msgSender()) + uint64(_mintAmount));
2162         _safeMint(_msgSender(), _mintAmount);
2163     }
2164 
2165     /**
2166      * @dev public mint for everyone
2167      */
2168     function mint(uint256 _mintAmount)
2169         public
2170         payable
2171         _check_mint_compliance(_mintAmount)
2172         _check_mint_balance(_mintAmount)
2173     {
2174         require(!mintPaused, "The contract is paused!");
2175         _safeMint(_msgSender(), _mintAmount);
2176     }
2177 
2178     /**
2179      * @dev The owner mint NFT for the receiver
2180      */
2181     function mintTo(uint256 _mintAmount, address _receiver) public onlyOwner {
2182         require(
2183             totalSupply() + _mintAmount <= maxSupply,
2184             "Max supply exceeded!"
2185         );
2186         require(ownerMintAmount(_receiver) + _mintAmount <= maxMintAmountPreOwner, "mint amount limited");
2187         _safeMint(_receiver, _mintAmount);
2188     }
2189 
2190     /**
2191      * @dev return whitelist mint amount
2192      */
2193     function numberWhitelistMinted(address _owner)
2194         public
2195         view
2196         returns (uint256)
2197     {
2198         return _getAux(_owner);
2199     }
2200 
2201     function _startTokenId() internal view virtual override returns (uint256) {
2202         return 1;
2203     }
2204 
2205     /**
2206      * @dev This will set the price of every single NFT.
2207      */
2208     function setCost(uint256 _cost) public onlyOwner {
2209         cost = _cost;
2210     }
2211 
2212     /**
2213      * @dev This will set How many NFT can be mint in single Tx  .
2214      */
2215     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
2216         public
2217         onlyOwner
2218     {
2219         maxMintAmountPerTx = _maxMintAmountPerTx;
2220     }
2221 
2222     /**
2223      * @dev This will set How many NFT can a wallet to mint  .
2224      */
2225     function setMaxMintAmountPreOwner(uint256 _maxMintAmountPreOwner)
2226         public
2227         onlyOwner
2228     {
2229         maxMintAmountPreOwner = _maxMintAmountPreOwner;
2230     }
2231 
2232     /**
2233      * @dev This will set the base token url when revealed .
2234      */
2235     function setBaseTokenURI(string memory _baseUrl) public onlyOwner {
2236         baseTokenURI = _baseUrl;
2237     }
2238 
2239     /**
2240      * @dev This will enable or disable publit mint.if false, it should be public .
2241      */
2242     function setPaused(bool _state) public onlyOwner {
2243         mintPaused = _state;
2244     }
2245 
2246     /**
2247      * @dev This will set the merkle tree root of the whitelist .
2248      */
2249     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2250         merkleRoot = _merkleRoot;
2251     }
2252 
2253     /**
2254      * @dev This will enable or disaple whitelist mint.
2255      */
2256     function setWhitelistMintEnabled(bool _state) public onlyOwner {
2257         whitelistMintEnabled = _state;
2258     }
2259 
2260     /**
2261      * @dev This will set uri suffix.
2262      */
2263     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2264         uriSuffix = _uriSuffix;
2265     }
2266 
2267     /**
2268      * @dev This will transfer the remaining contract balance to the owner.
2269      */
2270     function withdraw() public onlyOwner nonReentrant {
2271         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2272         require(os);
2273     }
2274 
2275     /**
2276      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2277      */
2278     function tokenURI(uint256 tokenId)
2279         public
2280         view
2281         virtual
2282         override(ERC721A)
2283         returns (string memory)
2284     {
2285         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2286         string memory baseurl = _baseURI();
2287         return
2288             bytes(baseurl).length != 0
2289                 ? string(
2290                     abi.encodePacked(baseurl, _toString(tokenId), uriSuffix)
2291                 )
2292                 : "";
2293     }
2294 
2295     function _baseURI() internal view virtual override returns (string memory) {
2296         return baseTokenURI;
2297     }
2298 }