1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The tree and the proofs can be generated using our
12  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
13  * You will find a quickstart guide in the readme.
14  *
15  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
16  * hashing, or use a hash function other than keccak256 for hashing leaves.
17  * This is because the concatenation of a sorted pair of internal nodes in
18  * the merkle tree could be reinterpreted as a leaf value.
19  * OpenZeppelin's JavaScript library generates merkle trees that are safe
20  * against this attack out of the box.
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
80      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
84      *
85      * _Available since v4.7._
86      */
87     function multiProofVerify(
88         bytes32[] memory proof,
89         bool[] memory proofFlags,
90         bytes32 root,
91         bytes32[] memory leaves
92     ) internal pure returns (bool) {
93         return processMultiProof(proof, proofFlags, leaves) == root;
94     }
95 
96     /**
97      * @dev Calldata version of {multiProofVerify}
98      *
99      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
100      *
101      * _Available since v4.7._
102      */
103     function multiProofVerifyCalldata(
104         bytes32[] calldata proof,
105         bool[] calldata proofFlags,
106         bytes32 root,
107         bytes32[] memory leaves
108     ) internal pure returns (bool) {
109         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
110     }
111 
112     /**
113      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
114      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
115      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
116      * respectively.
117      *
118      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
119      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
120      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
121      *
122      * _Available since v4.7._
123      */
124     function processMultiProof(
125         bytes32[] memory proof,
126         bool[] memory proofFlags,
127         bytes32[] memory leaves
128     ) internal pure returns (bytes32 merkleRoot) {
129         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
130         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
131         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
132         // the merkle tree.
133         uint256 leavesLen = leaves.length;
134         uint256 totalHashes = proofFlags.length;
135 
136         // Check proof validity.
137         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
138 
139         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
140         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
141         bytes32[] memory hashes = new bytes32[](totalHashes);
142         uint256 leafPos = 0;
143         uint256 hashPos = 0;
144         uint256 proofPos = 0;
145         // At each step, we compute the next hash using two values:
146         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
147         //   get the next hash.
148         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
149         //   `proof` array.
150         for (uint256 i = 0; i < totalHashes; i++) {
151             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
152             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
153             hashes[i] = _hashPair(a, b);
154         }
155 
156         if (totalHashes > 0) {
157             return hashes[totalHashes - 1];
158         } else if (leavesLen > 0) {
159             return leaves[0];
160         } else {
161             return proof[0];
162         }
163     }
164 
165     /**
166      * @dev Calldata version of {processMultiProof}.
167      *
168      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
169      *
170      * _Available since v4.7._
171      */
172     function processMultiProofCalldata(
173         bytes32[] calldata proof,
174         bool[] calldata proofFlags,
175         bytes32[] memory leaves
176     ) internal pure returns (bytes32 merkleRoot) {
177         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
178         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
179         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
180         // the merkle tree.
181         uint256 leavesLen = leaves.length;
182         uint256 totalHashes = proofFlags.length;
183 
184         // Check proof validity.
185         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
186 
187         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
188         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
189         bytes32[] memory hashes = new bytes32[](totalHashes);
190         uint256 leafPos = 0;
191         uint256 hashPos = 0;
192         uint256 proofPos = 0;
193         // At each step, we compute the next hash using two values:
194         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
195         //   get the next hash.
196         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
197         //   `proof` array.
198         for (uint256 i = 0; i < totalHashes; i++) {
199             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
200             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
201             hashes[i] = _hashPair(a, b);
202         }
203 
204         if (totalHashes > 0) {
205             return hashes[totalHashes - 1];
206         } else if (leavesLen > 0) {
207             return leaves[0];
208         } else {
209             return proof[0];
210         }
211     }
212 
213     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
214         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
215     }
216 
217     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
218         /// @solidity memory-safe-assembly
219         assembly {
220             mstore(0x00, a)
221             mstore(0x20, b)
222             value := keccak256(0x00, 0x40)
223         }
224     }
225 }
226 
227 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
228 
229 
230 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Contract module that helps prevent reentrant calls to a function.
236  *
237  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
238  * available, which can be applied to functions to make sure there are no nested
239  * (reentrant) calls to them.
240  *
241  * Note that because there is a single `nonReentrant` guard, functions marked as
242  * `nonReentrant` may not call one another. This can be worked around by making
243  * those functions `private`, and then adding `external` `nonReentrant` entry
244  * points to them.
245  *
246  * TIP: If you would like to learn more about reentrancy and alternative ways
247  * to protect against it, check out our blog post
248  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
249  */
250 abstract contract ReentrancyGuard {
251     // Booleans are more expensive than uint256 or any type that takes up a full
252     // word because each write operation emits an extra SLOAD to first read the
253     // slot's contents, replace the bits taken up by the boolean, and then write
254     // back. This is the compiler's defense against contract upgrades and
255     // pointer aliasing, and it cannot be disabled.
256 
257     // The values being non-zero value makes deployment a bit more expensive,
258     // but in exchange the refund on every call to nonReentrant will be lower in
259     // amount. Since refunds are capped to a percentage of the total
260     // transaction's gas, it is best to keep them low in cases like this one, to
261     // increase the likelihood of the full refund coming into effect.
262     uint256 private constant _NOT_ENTERED = 1;
263     uint256 private constant _ENTERED = 2;
264 
265     uint256 private _status;
266 
267     constructor() {
268         _status = _NOT_ENTERED;
269     }
270 
271     /**
272      * @dev Prevents a contract from calling itself, directly or indirectly.
273      * Calling a `nonReentrant` function from another `nonReentrant`
274      * function is not supported. It is possible to prevent this from happening
275      * by making the `nonReentrant` function external, and making it call a
276      * `private` function that does the actual work.
277      */
278     modifier nonReentrant() {
279         _nonReentrantBefore();
280         _;
281         _nonReentrantAfter();
282     }
283 
284     function _nonReentrantBefore() private {
285         // On the first call to nonReentrant, _status will be _NOT_ENTERED
286         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
287 
288         // Any calls to nonReentrant after this point will fail
289         _status = _ENTERED;
290     }
291 
292     function _nonReentrantAfter() private {
293         // By storing the original value once again, a refund is triggered (see
294         // https://eips.ethereum.org/EIPS/eip-2200)
295         _status = _NOT_ENTERED;
296     }
297 }
298 
299 // File: @openzeppelin/contracts/utils/Context.sol
300 
301 
302 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
303 
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @dev Provides information about the current execution context, including the
308  * sender of the transaction and its data. While these are generally available
309  * via msg.sender and msg.data, they should not be accessed in such a direct
310  * manner, since when dealing with meta-transactions the account sending and
311  * paying for execution may not be the actual sender (as far as an application
312  * is concerned).
313  *
314  * This contract is only required for intermediate, library-like contracts.
315  */
316 abstract contract Context {
317     function _msgSender() internal view virtual returns (address) {
318         return msg.sender;
319     }
320 
321     function _msgData() internal view virtual returns (bytes calldata) {
322         return msg.data;
323     }
324 }
325 
326 // File: @openzeppelin/contracts/access/Ownable.sol
327 
328 
329 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 
334 /**
335  * @dev Contract module which provides a basic access control mechanism, where
336  * there is an account (an owner) that can be granted exclusive access to
337  * specific functions.
338  *
339  * By default, the owner account will be the one that deploys the contract. This
340  * can later be changed with {transferOwnership}.
341  *
342  * This module is used through inheritance. It will make available the modifier
343  * `onlyOwner`, which can be applied to your functions to restrict their use to
344  * the owner.
345  */
346 abstract contract Ownable is Context {
347     address private _owner;
348 
349     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
350 
351     /**
352      * @dev Initializes the contract setting the deployer as the initial owner.
353      */
354     constructor() {
355         _transferOwnership(_msgSender());
356     }
357 
358     /**
359      * @dev Throws if called by any account other than the owner.
360      */
361     modifier onlyOwner() {
362         _checkOwner();
363         _;
364     }
365 
366     /**
367      * @dev Returns the address of the current owner.
368      */
369     function owner() public view virtual returns (address) {
370         return _owner;
371     }
372 
373     /**
374      * @dev Throws if the sender is not the owner.
375      */
376     function _checkOwner() internal view virtual {
377         require(owner() == _msgSender(), "Ownable: caller is not the owner");
378     }
379 
380     /**
381      * @dev Leaves the contract without owner. It will not be possible to call
382      * `onlyOwner` functions anymore. Can only be called by the current owner.
383      *
384      * NOTE: Renouncing ownership will leave the contract without an owner,
385      * thereby removing any functionality that is only available to the owner.
386      */
387     function renounceOwnership() public virtual onlyOwner {
388         _transferOwnership(address(0));
389     }
390 
391     /**
392      * @dev Transfers ownership of the contract to a new account (`newOwner`).
393      * Can only be called by the current owner.
394      */
395     function transferOwnership(address newOwner) public virtual onlyOwner {
396         require(newOwner != address(0), "Ownable: new owner is the zero address");
397         _transferOwnership(newOwner);
398     }
399 
400     /**
401      * @dev Transfers ownership of the contract to a new account (`newOwner`).
402      * Internal function without access restriction.
403      */
404     function _transferOwnership(address newOwner) internal virtual {
405         address oldOwner = _owner;
406         _owner = newOwner;
407         emit OwnershipTransferred(oldOwner, newOwner);
408     }
409 }
410 
411 // File: IERC721A.sol
412 
413 
414 // ERC721A Contracts v4.2.3
415 // Creator: Chiru Labs
416 
417 pragma solidity ^0.8.4;
418 
419 /**
420  * @dev Interface of ERC721A.
421  */
422 interface IERC721A {
423     /**
424      * The caller must own the token or be an approved operator.
425      */
426     error ApprovalCallerNotOwnerNorApproved();
427 
428     /**
429      * The token does not exist.
430      */
431     error ApprovalQueryForNonexistentToken();
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
585     ) external payable;
586 
587     /**
588      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external payable;
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
616     ) external payable;
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
632     function approve(address to, uint256 tokenId) external payable;
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
695 // File: ERC721A.sol
696 
697 
698 // ERC721A Contracts v4.2.3
699 // Creator: Chiru Labs
700 
701 pragma solidity ^0.8.4;
702 
703 
704 /**
705  * @dev Interface of ERC721 token receiver.
706  */
707 interface ERC721A__IERC721Receiver {
708     function onERC721Received(
709         address operator,
710         address from,
711         uint256 tokenId,
712         bytes calldata data
713     ) external returns (bytes4);
714 }
715 
716 /**
717  * @title ERC721A
718  *
719  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
720  * Non-Fungible Token Standard, including the Metadata extension.
721  * Optimized for lower gas during batch mints.
722  *
723  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
724  * starting from `_startTokenId()`.
725  *
726  * Assumptions:
727  *
728  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
729  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
730  */
731 contract ERC721A is IERC721A {
732     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
733     struct TokenApprovalRef {
734         address value;
735     }
736 
737     // =============================================================
738     //                           CONSTANTS
739     // =============================================================
740 
741     // Mask of an entry in packed address data.
742     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
743 
744     // The bit position of `numberMinted` in packed address data.
745     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
746 
747     // The bit position of `numberBurned` in packed address data.
748     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
749 
750     // The bit position of `aux` in packed address data.
751     uint256 private constant _BITPOS_AUX = 192;
752 
753     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
754     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
755 
756     // The bit position of `startTimestamp` in packed ownership.
757     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
758 
759     // The bit mask of the `burned` bit in packed ownership.
760     uint256 private constant _BITMASK_BURNED = 1 << 224;
761 
762     // The bit position of the `nextInitialized` bit in packed ownership.
763     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
764 
765     // The bit mask of the `nextInitialized` bit in packed ownership.
766     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
767 
768     // The bit position of `extraData` in packed ownership.
769     uint256 private constant _BITPOS_EXTRA_DATA = 232;
770 
771     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
772     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
773 
774     // The mask of the lower 160 bits for addresses.
775     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
776 
777     // The maximum `quantity` that can be minted with {_mintERC2309}.
778     // This limit is to prevent overflows on the address data entries.
779     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
780     // is required to cause an overflow, which is unrealistic.
781     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
782 
783     // The `Transfer` event signature is given by:
784     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
785     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
786         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
787 
788     // =============================================================
789     //                            STORAGE
790     // =============================================================
791 
792     // The next token ID to be minted.
793     uint256 private _currentIndex;
794 
795     // The number of tokens burned.
796     uint256 private _burnCounter;
797 
798     // Token name
799     string private _name;
800 
801     // Token symbol
802     string private _symbol;
803 
804     // Mapping from token ID to ownership details
805     // An empty struct value does not necessarily mean the token is unowned.
806     // See {_packedOwnershipOf} implementation for details.
807     //
808     // Bits Layout:
809     // - [0..159]   `addr`
810     // - [160..223] `startTimestamp`
811     // - [224]      `burned`
812     // - [225]      `nextInitialized`
813     // - [232..255] `extraData`
814     mapping(uint256 => uint256) private _packedOwnerships;
815 
816     // Mapping owner address to address data.
817     //
818     // Bits Layout:
819     // - [0..63]    `balance`
820     // - [64..127]  `numberMinted`
821     // - [128..191] `numberBurned`
822     // - [192..255] `aux`
823     mapping(address => uint256) private _packedAddressData;
824 
825     // Mapping from token ID to approved address.
826     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
827 
828     // Mapping from owner to operator approvals
829     mapping(address => mapping(address => bool)) private _operatorApprovals;
830 
831     // =============================================================
832     //                          CONSTRUCTOR
833     // =============================================================
834 
835     constructor(string memory name_, string memory symbol_) {
836         _name = name_;
837         _symbol = symbol_;
838         _currentIndex = _startTokenId();
839     }
840 
841     // =============================================================
842     //                   TOKEN COUNTING OPERATIONS
843     // =============================================================
844 
845     /**
846      * @dev Returns the starting token ID.
847      * To change the starting token ID, please override this function.
848      */
849     function _startTokenId() internal view virtual returns (uint256) {
850         return 0;
851     }
852 
853     /**
854      * @dev Returns the next token ID to be minted.
855      */
856     function _nextTokenId() internal view virtual returns (uint256) {
857         return _currentIndex;
858     }
859 
860     /**
861      * @dev Returns the total number of tokens in existence.
862      * Burned tokens will reduce the count.
863      * To get the total number of tokens minted, please see {_totalMinted}.
864      */
865     function totalSupply() public view virtual override returns (uint256) {
866         // Counter underflow is impossible as _burnCounter cannot be incremented
867         // more than `_currentIndex - _startTokenId()` times.
868         unchecked {
869             return _currentIndex - _burnCounter - _startTokenId();
870         }
871     }
872 
873     /**
874      * @dev Returns the total amount of tokens minted in the contract.
875      */
876     function _totalMinted() internal view virtual returns (uint256) {
877         // Counter underflow is impossible as `_currentIndex` does not decrement,
878         // and it is initialized to `_startTokenId()`.
879         unchecked {
880             return _currentIndex - _startTokenId();
881         }
882     }
883 
884     /**
885      * @dev Returns the total number of tokens burned.
886      */
887     function _totalBurned() internal view virtual returns (uint256) {
888         return _burnCounter;
889     }
890 
891     // =============================================================
892     //                    ADDRESS DATA OPERATIONS
893     // =============================================================
894 
895     /**
896      * @dev Returns the number of tokens in `owner`'s account.
897      */
898     function balanceOf(address owner) public view virtual override returns (uint256) {
899         if (owner == address(0)) revert BalanceQueryForZeroAddress();
900         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
901     }
902 
903     /**
904      * Returns the number of tokens minted by `owner`.
905      */
906     function _numberMinted(address owner) internal view returns (uint256) {
907         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
908     }
909 
910     /**
911      * Returns the number of tokens burned by or on behalf of `owner`.
912      */
913     function _numberBurned(address owner) internal view returns (uint256) {
914         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
915     }
916 
917     /**
918      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
919      */
920     function _getAux(address owner) internal view returns (uint64) {
921         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
922     }
923 
924     /**
925      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
926      * If there are multiple variables, please pack them into a uint64.
927      */
928     function _setAux(address owner, uint64 aux) internal virtual {
929         uint256 packed = _packedAddressData[owner];
930         uint256 auxCasted;
931         // Cast `aux` with assembly to avoid redundant masking.
932         assembly {
933             auxCasted := aux
934         }
935         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
936         _packedAddressData[owner] = packed;
937     }
938 
939     // =============================================================
940     //                            IERC165
941     // =============================================================
942 
943     /**
944      * @dev Returns true if this contract implements the interface defined by
945      * `interfaceId`. See the corresponding
946      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
947      * to learn more about how these ids are created.
948      *
949      * This function call must use less than 30000 gas.
950      */
951     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
952         // The interface IDs are constants representing the first 4 bytes
953         // of the XOR of all function selectors in the interface.
954         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
955         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
956         return
957             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
958             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
959             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
960     }
961 
962     // =============================================================
963     //                        IERC721Metadata
964     // =============================================================
965 
966     /**
967      * @dev Returns the token collection name.
968      */
969     function name() public view virtual override returns (string memory) {
970         return _name;
971     }
972 
973     /**
974      * @dev Returns the token collection symbol.
975      */
976     function symbol() public view virtual override returns (string memory) {
977         return _symbol;
978     }
979 
980     /**
981      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
982      */
983     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
984         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
985 
986         string memory baseURI = _baseURI();
987         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
988     }
989 
990     /**
991      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
992      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
993      * by default, it can be overridden in child contracts.
994      */
995     function _baseURI() internal view virtual returns (string memory) {
996         return '';
997     }
998 
999     // =============================================================
1000     //                     OWNERSHIPS OPERATIONS
1001     // =============================================================
1002 
1003     /**
1004      * @dev Returns the owner of the `tokenId` token.
1005      *
1006      * Requirements:
1007      *
1008      * - `tokenId` must exist.
1009      */
1010     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1011         return address(uint160(_packedOwnershipOf(tokenId)));
1012     }
1013 
1014     /**
1015      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1016      * It gradually moves to O(1) as tokens get transferred around over time.
1017      */
1018     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1019         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1020     }
1021 
1022     /**
1023      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1024      */
1025     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1026         return _unpackedOwnership(_packedOwnerships[index]);
1027     }
1028 
1029     /**
1030      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1031      */
1032     function _initializeOwnershipAt(uint256 index) internal virtual {
1033         if (_packedOwnerships[index] == 0) {
1034             _packedOwnerships[index] = _packedOwnershipOf(index);
1035         }
1036     }
1037 
1038     /**
1039      * Returns the packed ownership data of `tokenId`.
1040      */
1041     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1042         uint256 curr = tokenId;
1043 
1044         unchecked {
1045             if (_startTokenId() <= curr)
1046                 if (curr < _currentIndex) {
1047                     uint256 packed = _packedOwnerships[curr];
1048                     // If not burned.
1049                     if (packed & _BITMASK_BURNED == 0) {
1050                         // Invariant:
1051                         // There will always be an initialized ownership slot
1052                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1053                         // before an unintialized ownership slot
1054                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1055                         // Hence, `curr` will not underflow.
1056                         //
1057                         // We can directly compare the packed value.
1058                         // If the address is zero, packed will be zero.
1059                         while (packed == 0) {
1060                             packed = _packedOwnerships[--curr];
1061                         }
1062                         return packed;
1063                     }
1064                 }
1065         }
1066         revert OwnerQueryForNonexistentToken();
1067     }
1068 
1069     /**
1070      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1071      */
1072     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1073         ownership.addr = address(uint160(packed));
1074         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1075         ownership.burned = packed & _BITMASK_BURNED != 0;
1076         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1077     }
1078 
1079     /**
1080      * @dev Packs ownership data into a single uint256.
1081      */
1082     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1083         assembly {
1084             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1085             owner := and(owner, _BITMASK_ADDRESS)
1086             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1087             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1088         }
1089     }
1090 
1091     /**
1092      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1093      */
1094     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1095         // For branchless setting of the `nextInitialized` flag.
1096         assembly {
1097             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1098             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1099         }
1100     }
1101 
1102     // =============================================================
1103     //                      APPROVAL OPERATIONS
1104     // =============================================================
1105 
1106     /**
1107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1108      * The approval is cleared when the token is transferred.
1109      *
1110      * Only a single account can be approved at a time, so approving the
1111      * zero address clears previous approvals.
1112      *
1113      * Requirements:
1114      *
1115      * - The caller must own the token or be an approved operator.
1116      * - `tokenId` must exist.
1117      *
1118      * Emits an {Approval} event.
1119      */
1120     function approve(address to, uint256 tokenId) public payable virtual override {
1121         address owner = ownerOf(tokenId);
1122 
1123         if (_msgSenderERC721A() != owner)
1124             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1125                 revert ApprovalCallerNotOwnerNorApproved();
1126             }
1127 
1128         _tokenApprovals[tokenId].value = to;
1129         emit Approval(owner, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev Returns the account approved for `tokenId` token.
1134      *
1135      * Requirements:
1136      *
1137      * - `tokenId` must exist.
1138      */
1139     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1140         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1141 
1142         return _tokenApprovals[tokenId].value;
1143     }
1144 
1145     /**
1146      * @dev Approve or remove `operator` as an operator for the caller.
1147      * Operators can call {transferFrom} or {safeTransferFrom}
1148      * for any token owned by the caller.
1149      *
1150      * Requirements:
1151      *
1152      * - The `operator` cannot be the caller.
1153      *
1154      * Emits an {ApprovalForAll} event.
1155      */
1156     function setApprovalForAll(address operator, bool approved) public virtual override {
1157         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1158         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1159     }
1160 
1161     /**
1162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1163      *
1164      * See {setApprovalForAll}.
1165      */
1166     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1167         return _operatorApprovals[owner][operator];
1168     }
1169 
1170     /**
1171      * @dev Returns whether `tokenId` exists.
1172      *
1173      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1174      *
1175      * Tokens start existing when they are minted. See {_mint}.
1176      */
1177     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1178         return
1179             _startTokenId() <= tokenId &&
1180             tokenId < _currentIndex && // If within bounds,
1181             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1182     }
1183 
1184     /**
1185      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1186      */
1187     function _isSenderApprovedOrOwner(
1188         address approvedAddress,
1189         address owner,
1190         address msgSender
1191     ) private pure returns (bool result) {
1192         assembly {
1193             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1194             owner := and(owner, _BITMASK_ADDRESS)
1195             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1196             msgSender := and(msgSender, _BITMASK_ADDRESS)
1197             // `msgSender == owner || msgSender == approvedAddress`.
1198             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1199         }
1200     }
1201 
1202     /**
1203      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1204      */
1205     function _getApprovedSlotAndAddress(uint256 tokenId)
1206         private
1207         view
1208         returns (uint256 approvedAddressSlot, address approvedAddress)
1209     {
1210         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1211         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1212         assembly {
1213             approvedAddressSlot := tokenApproval.slot
1214             approvedAddress := sload(approvedAddressSlot)
1215         }
1216     }
1217 
1218     // =============================================================
1219     //                      TRANSFER OPERATIONS
1220     // =============================================================
1221 
1222     /**
1223      * @dev Transfers `tokenId` from `from` to `to`.
1224      *
1225      * Requirements:
1226      *
1227      * - `from` cannot be the zero address.
1228      * - `to` cannot be the zero address.
1229      * - `tokenId` token must be owned by `from`.
1230      * - If the caller is not `from`, it must be approved to move this token
1231      * by either {approve} or {setApprovalForAll}.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function transferFrom(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) public payable virtual override {
1240         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1241 
1242         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1243 
1244         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1245 
1246         // The nested ifs save around 20+ gas over a compound boolean condition.
1247         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1248             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1249 
1250         if (to == address(0)) revert TransferToZeroAddress();
1251 
1252         _beforeTokenTransfers(from, to, tokenId, 1);
1253 
1254         // Clear approvals from the previous owner.
1255         assembly {
1256             if approvedAddress {
1257                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1258                 sstore(approvedAddressSlot, 0)
1259             }
1260         }
1261 
1262         // Underflow of the sender's balance is impossible because we check for
1263         // ownership above and the recipient's balance can't realistically overflow.
1264         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1265         unchecked {
1266             // We can directly increment and decrement the balances.
1267             --_packedAddressData[from]; // Updates: `balance -= 1`.
1268             ++_packedAddressData[to]; // Updates: `balance += 1`.
1269 
1270             // Updates:
1271             // - `address` to the next owner.
1272             // - `startTimestamp` to the timestamp of transfering.
1273             // - `burned` to `false`.
1274             // - `nextInitialized` to `true`.
1275             _packedOwnerships[tokenId] = _packOwnershipData(
1276                 to,
1277                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1278             );
1279 
1280             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1281             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1282                 uint256 nextTokenId = tokenId + 1;
1283                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1284                 if (_packedOwnerships[nextTokenId] == 0) {
1285                     // If the next slot is within bounds.
1286                     if (nextTokenId != _currentIndex) {
1287                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1288                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1289                     }
1290                 }
1291             }
1292         }
1293 
1294         emit Transfer(from, to, tokenId);
1295         _afterTokenTransfers(from, to, tokenId, 1);
1296     }
1297 
1298     /**
1299      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1300      */
1301     function safeTransferFrom(
1302         address from,
1303         address to,
1304         uint256 tokenId
1305     ) public payable virtual override {
1306         safeTransferFrom(from, to, tokenId, '');
1307     }
1308 
1309     /**
1310      * @dev Safely transfers `tokenId` token from `from` to `to`.
1311      *
1312      * Requirements:
1313      *
1314      * - `from` cannot be the zero address.
1315      * - `to` cannot be the zero address.
1316      * - `tokenId` token must exist and be owned by `from`.
1317      * - If the caller is not `from`, it must be approved to move this token
1318      * by either {approve} or {setApprovalForAll}.
1319      * - If `to` refers to a smart contract, it must implement
1320      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1321      *
1322      * Emits a {Transfer} event.
1323      */
1324     function safeTransferFrom(
1325         address from,
1326         address to,
1327         uint256 tokenId,
1328         bytes memory _data
1329     ) public payable virtual override {
1330         transferFrom(from, to, tokenId);
1331         if (to.code.length != 0)
1332             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1333                 revert TransferToNonERC721ReceiverImplementer();
1334             }
1335     }
1336 
1337     /**
1338      * @dev Hook that is called before a set of serially-ordered token IDs
1339      * are about to be transferred. This includes minting.
1340      * And also called before burning one token.
1341      *
1342      * `startTokenId` - the first token ID to be transferred.
1343      * `quantity` - the amount to be transferred.
1344      *
1345      * Calling conditions:
1346      *
1347      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1348      * transferred to `to`.
1349      * - When `from` is zero, `tokenId` will be minted for `to`.
1350      * - When `to` is zero, `tokenId` will be burned by `from`.
1351      * - `from` and `to` are never both zero.
1352      */
1353     function _beforeTokenTransfers(
1354         address from,
1355         address to,
1356         uint256 startTokenId,
1357         uint256 quantity
1358     ) internal virtual {}
1359 
1360     /**
1361      * @dev Hook that is called after a set of serially-ordered token IDs
1362      * have been transferred. This includes minting.
1363      * And also called after one token has been burned.
1364      *
1365      * `startTokenId` - the first token ID to be transferred.
1366      * `quantity` - the amount to be transferred.
1367      *
1368      * Calling conditions:
1369      *
1370      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1371      * transferred to `to`.
1372      * - When `from` is zero, `tokenId` has been minted for `to`.
1373      * - When `to` is zero, `tokenId` has been burned by `from`.
1374      * - `from` and `to` are never both zero.
1375      */
1376     function _afterTokenTransfers(
1377         address from,
1378         address to,
1379         uint256 startTokenId,
1380         uint256 quantity
1381     ) internal virtual {}
1382 
1383     /**
1384      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1385      *
1386      * `from` - Previous owner of the given token ID.
1387      * `to` - Target address that will receive the token.
1388      * `tokenId` - Token ID to be transferred.
1389      * `_data` - Optional data to send along with the call.
1390      *
1391      * Returns whether the call correctly returned the expected magic value.
1392      */
1393     function _checkContractOnERC721Received(
1394         address from,
1395         address to,
1396         uint256 tokenId,
1397         bytes memory _data
1398     ) private returns (bool) {
1399         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1400             bytes4 retval
1401         ) {
1402             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1403         } catch (bytes memory reason) {
1404             if (reason.length == 0) {
1405                 revert TransferToNonERC721ReceiverImplementer();
1406             } else {
1407                 assembly {
1408                     revert(add(32, reason), mload(reason))
1409                 }
1410             }
1411         }
1412     }
1413 
1414     // =============================================================
1415     //                        MINT OPERATIONS
1416     // =============================================================
1417 
1418     /**
1419      * @dev Mints `quantity` tokens and transfers them to `to`.
1420      *
1421      * Requirements:
1422      *
1423      * - `to` cannot be the zero address.
1424      * - `quantity` must be greater than 0.
1425      *
1426      * Emits a {Transfer} event for each mint.
1427      */
1428     function _mint(address to, uint256 quantity) internal virtual {
1429         uint256 startTokenId = _currentIndex;
1430         if (quantity == 0) revert MintZeroQuantity();
1431 
1432         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1433 
1434         // Overflows are incredibly unrealistic.
1435         // `balance` and `numberMinted` have a maximum limit of 2**64.
1436         // `tokenId` has a maximum limit of 2**256.
1437         unchecked {
1438             // Updates:
1439             // - `balance += quantity`.
1440             // - `numberMinted += quantity`.
1441             //
1442             // We can directly add to the `balance` and `numberMinted`.
1443             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1444 
1445             // Updates:
1446             // - `address` to the owner.
1447             // - `startTimestamp` to the timestamp of minting.
1448             // - `burned` to `false`.
1449             // - `nextInitialized` to `quantity == 1`.
1450             _packedOwnerships[startTokenId] = _packOwnershipData(
1451                 to,
1452                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1453             );
1454 
1455             uint256 toMasked;
1456             uint256 end = startTokenId + quantity;
1457 
1458             // Use assembly to loop and emit the `Transfer` event for gas savings.
1459             // The duplicated `log4` removes an extra check and reduces stack juggling.
1460             // The assembly, together with the surrounding Solidity code, have been
1461             // delicately arranged to nudge the compiler into producing optimized opcodes.
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
1475                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1476                 // that overflows uint256 will make the loop run out of gas.
1477                 // The compiler will optimize the `iszero` away for performance.
1478                 for {
1479                     let tokenId := add(startTokenId, 1)
1480                 } iszero(eq(tokenId, end)) {
1481                     tokenId := add(tokenId, 1)
1482                 } {
1483                     // Emit the `Transfer` event. Similar to above.
1484                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1485                 }
1486             }
1487             if (toMasked == 0) revert MintToZeroAddress();
1488 
1489             _currentIndex = end;
1490         }
1491         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1492     }
1493 
1494     /**
1495      * @dev Mints `quantity` tokens and transfers them to `to`.
1496      *
1497      * This function is intended for efficient minting only during contract creation.
1498      *
1499      * It emits only one {ConsecutiveTransfer} as defined in
1500      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1501      * instead of a sequence of {Transfer} event(s).
1502      *
1503      * Calling this function outside of contract creation WILL make your contract
1504      * non-compliant with the ERC721 standard.
1505      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1506      * {ConsecutiveTransfer} event is only permissible during contract creation.
1507      *
1508      * Requirements:
1509      *
1510      * - `to` cannot be the zero address.
1511      * - `quantity` must be greater than 0.
1512      *
1513      * Emits a {ConsecutiveTransfer} event.
1514      */
1515     function _mintERC2309(address to, uint256 quantity) internal virtual {
1516         uint256 startTokenId = _currentIndex;
1517         if (to == address(0)) revert MintToZeroAddress();
1518         if (quantity == 0) revert MintZeroQuantity();
1519         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1520 
1521         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1522 
1523         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1524         unchecked {
1525             // Updates:
1526             // - `balance += quantity`.
1527             // - `numberMinted += quantity`.
1528             //
1529             // We can directly add to the `balance` and `numberMinted`.
1530             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1531 
1532             // Updates:
1533             // - `address` to the owner.
1534             // - `startTimestamp` to the timestamp of minting.
1535             // - `burned` to `false`.
1536             // - `nextInitialized` to `quantity == 1`.
1537             _packedOwnerships[startTokenId] = _packOwnershipData(
1538                 to,
1539                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1540             );
1541 
1542             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1543 
1544             _currentIndex = startTokenId + quantity;
1545         }
1546         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1547     }
1548 
1549     /**
1550      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1551      *
1552      * Requirements:
1553      *
1554      * - If `to` refers to a smart contract, it must implement
1555      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1556      * - `quantity` must be greater than 0.
1557      *
1558      * See {_mint}.
1559      *
1560      * Emits a {Transfer} event for each mint.
1561      */
1562     function _safeMint(
1563         address to,
1564         uint256 quantity,
1565         bytes memory _data
1566     ) internal virtual {
1567         _mint(to, quantity);
1568 
1569         unchecked {
1570             if (to.code.length != 0) {
1571                 uint256 end = _currentIndex;
1572                 uint256 index = end - quantity;
1573                 do {
1574                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1575                         revert TransferToNonERC721ReceiverImplementer();
1576                     }
1577                 } while (index < end);
1578                 // Reentrancy protection.
1579                 if (_currentIndex != end) revert();
1580             }
1581         }
1582     }
1583 
1584     /**
1585      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1586      */
1587     function _safeMint(address to, uint256 quantity) internal virtual {
1588         _safeMint(to, quantity, '');
1589     }
1590 
1591     // =============================================================
1592     //                        BURN OPERATIONS
1593     // =============================================================
1594 
1595     /**
1596      * @dev Equivalent to `_burn(tokenId, false)`.
1597      */
1598     function _burn(uint256 tokenId) internal virtual {
1599         _burn(tokenId, false);
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
1612     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1613         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1614 
1615         address from = address(uint160(prevOwnershipPacked));
1616 
1617         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1618 
1619         if (approvalCheck) {
1620             // The nested ifs save around 20+ gas over a compound boolean condition.
1621             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1622                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1623         }
1624 
1625         _beforeTokenTransfers(from, address(0), tokenId, 1);
1626 
1627         // Clear approvals from the previous owner.
1628         assembly {
1629             if approvedAddress {
1630                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1631                 sstore(approvedAddressSlot, 0)
1632             }
1633         }
1634 
1635         // Underflow of the sender's balance is impossible because we check for
1636         // ownership above and the recipient's balance can't realistically overflow.
1637         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1638         unchecked {
1639             // Updates:
1640             // - `balance -= 1`.
1641             // - `numberBurned += 1`.
1642             //
1643             // We can directly decrement the balance, and increment the number burned.
1644             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1645             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1646 
1647             // Updates:
1648             // - `address` to the last owner.
1649             // - `startTimestamp` to the timestamp of burning.
1650             // - `burned` to `true`.
1651             // - `nextInitialized` to `true`.
1652             _packedOwnerships[tokenId] = _packOwnershipData(
1653                 from,
1654                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1655             );
1656 
1657             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1658             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1659                 uint256 nextTokenId = tokenId + 1;
1660                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1661                 if (_packedOwnerships[nextTokenId] == 0) {
1662                     // If the next slot is within bounds.
1663                     if (nextTokenId != _currentIndex) {
1664                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1665                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1666                     }
1667                 }
1668             }
1669         }
1670 
1671         emit Transfer(from, address(0), tokenId);
1672         _afterTokenTransfers(from, address(0), tokenId, 1);
1673 
1674         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1675         unchecked {
1676             _burnCounter++;
1677         }
1678     }
1679 
1680     // =============================================================
1681     //                     EXTRA DATA OPERATIONS
1682     // =============================================================
1683 
1684     /**
1685      * @dev Directly sets the extra data for the ownership data `index`.
1686      */
1687     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1688         uint256 packed = _packedOwnerships[index];
1689         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1690         uint256 extraDataCasted;
1691         // Cast `extraData` with assembly to avoid redundant masking.
1692         assembly {
1693             extraDataCasted := extraData
1694         }
1695         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1696         _packedOwnerships[index] = packed;
1697     }
1698 
1699     /**
1700      * @dev Called during each token transfer to set the 24bit `extraData` field.
1701      * Intended to be overridden by the cosumer contract.
1702      *
1703      * `previousExtraData` - the value of `extraData` before transfer.
1704      *
1705      * Calling conditions:
1706      *
1707      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1708      * transferred to `to`.
1709      * - When `from` is zero, `tokenId` will be minted for `to`.
1710      * - When `to` is zero, `tokenId` will be burned by `from`.
1711      * - `from` and `to` are never both zero.
1712      */
1713     function _extraData(
1714         address from,
1715         address to,
1716         uint24 previousExtraData
1717     ) internal view virtual returns (uint24) {}
1718 
1719     /**
1720      * @dev Returns the next extra data for the packed ownership data.
1721      * The returned result is shifted into position.
1722      */
1723     function _nextExtraData(
1724         address from,
1725         address to,
1726         uint256 prevOwnershipPacked
1727     ) private view returns (uint256) {
1728         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1729         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1730     }
1731 
1732     // =============================================================
1733     //                       OTHER OPERATIONS
1734     // =============================================================
1735 
1736     /**
1737      * @dev Returns the message sender (defaults to `msg.sender`).
1738      *
1739      * If you are writing GSN compatible contracts, you need to override this function.
1740      */
1741     function _msgSenderERC721A() internal view virtual returns (address) {
1742         return msg.sender;
1743     }
1744 
1745     /**
1746      * @dev Converts a uint256 to its ASCII string decimal representation.
1747      */
1748     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1749         assembly {
1750             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1751             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1752             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1753             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1754             let m := add(mload(0x40), 0xa0)
1755             // Update the free memory pointer to allocate.
1756             mstore(0x40, m)
1757             // Assign the `str` to the end.
1758             str := sub(m, 0x20)
1759             // Zeroize the slot after the string.
1760             mstore(str, 0)
1761 
1762             // Cache the end of the memory to calculate the length later.
1763             let end := str
1764 
1765             // We write the string from rightmost digit to leftmost digit.
1766             // The following is essentially a do-while loop that also handles the zero case.
1767             // prettier-ignore
1768             for { let temp := value } 1 {} {
1769                 str := sub(str, 1)
1770                 // Write the character to the pointer.
1771                 // The ASCII index of the '0' character is 48.
1772                 mstore8(str, add(48, mod(temp, 10)))
1773                 // Keep dividing `temp` until zero.
1774                 temp := div(temp, 10)
1775                 // prettier-ignore
1776                 if iszero(temp) { break }
1777             }
1778 
1779             let length := sub(end, str)
1780             // Move the pointer 32 bytes leftwards to make room for the length.
1781             str := sub(str, 0x20)
1782             // Store the length.
1783             mstore(str, length)
1784         }
1785     }
1786 }
1787 // File: DIOSNFT.sol
1788 
1789 pragma solidity ^0.8.7;
1790 /*
1791  .----------------.  .----------------.  .----------------.  .----------------. 
1792 | .--------------. || .--------------. || .--------------. || .--------------. |
1793 | |  ________    | || |     _____    | || |     ____     | || |    _______   | |
1794 | | |_   ___ `.  | || |    |_   _|   | || |   .'    `.   | || |   /  ___  |  | |
1795 | |   | |   `. \ | || |      | |     | || |  /  .--.  \  | || |  |  (__ \_|  | |
1796 | |   | |    | | | || |      | |     | || |  | |    | |  | || |   '.___`-.   | |
1797 | |  _| |___.' / | || |     _| |_    | || |  \  `--'  /  | || |  |`\____) |  | |
1798 | | |________.'  | || |    |_____|   | || |   `.____.'   | || |  |_______.'  | |
1799 | |              | || |              | || |              | || |              | |
1800 | '--------------' || '--------------' || '--------------' || '--------------' |
1801  '----------------'  '----------------'  '----------------'  '----------------'                                                                       
1802 */
1803 
1804 
1805 
1806 
1807 
1808 contract DIOsNFT is  ERC721A, Ownable, ReentrancyGuard {
1809     uint256 public constant MAX_SUPPLY = 8888;
1810     uint256 public constant WL1NORMAL_PRICE = 0.05 ether;
1811     uint256 public constant WL2DISCOUNT_PRICE = 0.03 ether;
1812     uint256 public constant PUB_PRICE = 0.07 ether;
1813     uint256 public constant WL1NORMAL_LIMIT = 2;
1814     uint256 public constant WL2DISCOUNT_LIMIT = 1;
1815     uint256 public constant WL3FM_LIMIT = 1;
1816     uint256 public constant PUB_LIMIT = 3;
1817 
1818     uint256 public constant WL1NORMAL_MAX_SUPPLY = 7910;
1819     uint256 public constant WL2DISCOUNT_MAX_SUPPLY = 30;
1820     uint256 public constant WL3FM_MAX_SUPPLY = 60;
1821 
1822     // mainNet
1823     uint256 public constant WL_SaleTime = 1668513600;
1824     uint256 public constant PUB_SaleTime = 1668600000;
1825 
1826 
1827     uint256 public minteds1 = 0;
1828     uint256 public minteds2 = 0;
1829     uint256 public minteds3 = 0;
1830     uint256 public minteds4 = 0;
1831 
1832     string public baseTokenURI;
1833     address public metaDataAddress ;
1834 
1835     mapping(address => uint256) public minteds1Map;
1836     mapping(address => uint256) public minteds2Map;
1837     mapping(address => uint256) public minteds3Map;
1838     mapping(address => uint256) public minteds4Map;
1839 
1840     mapping(address => bool) public disapprovedMarketplaces;
1841 
1842     bytes32 public root1 =
1843         0x6413a4cc6c8a43b348766863f59ba07981866a81b0f67f05b94476edb2a34f2b;
1844     bytes32 public root2 =
1845         0x656f5ac3b657fbaa450872f4ae6c2a5025d63fce686e42def340838eb672c9a2;
1846     bytes32 public root3 =
1847         0xc88bcf616c4d1031a250c488b6bdf2b343559b2610c4386343ff08f826fc2277;
1848 
1849     constructor(string memory _baseTokenUri)
1850         ERC721A("Meta-DIOs", "Meta-DIOs")
1851     {
1852         baseTokenURI = _baseTokenUri;
1853     }
1854 
1855 
1856     function WL1NORMAL_MINT(uint256 amount, bytes32[] memory proof) external payable{
1857         require(isWhiteLists1(proof, keccak256(abi.encodePacked(msg.sender))),"not WL1");
1858         require(msg.value >= amount* WL1NORMAL_PRICE,"value low");
1859         require(minteds1Map[msg.sender] + amount <= WL1NORMAL_LIMIT, "Limit exceeded");
1860         require(minteds1 + amount <= WL1NORMAL_MAX_SUPPLY, "Sold out!");
1861         require(block.timestamp >= WL_SaleTime , "Not on WL sale");
1862         require(PUB_SaleTime >= block.timestamp , "Not on WL sale");
1863         unchecked {
1864             minteds1Map[msg.sender] += amount;
1865             minteds1 += amount;
1866         }
1867 
1868         _mint(msg.sender, amount);
1869     }
1870 
1871     function WL2DISCOUNT_MINT(uint256 amount, bytes32[] memory proof) external payable{
1872         require(isWhiteLists2(proof, keccak256(abi.encodePacked(msg.sender))),"not WL2");
1873         require(msg.value >= amount* WL2DISCOUNT_PRICE,"value low");
1874         require(minteds2Map[msg.sender] + amount <= WL2DISCOUNT_LIMIT, "Limit exceeded");
1875         require(minteds2 + amount <= WL2DISCOUNT_MAX_SUPPLY, "Sold out!");
1876         require(block.timestamp >= WL_SaleTime, "Not on WL sale");
1877         require(PUB_SaleTime >= block.timestamp , "Not on WL sale");
1878         unchecked {
1879             minteds2Map[msg.sender] += amount;
1880             minteds2 += amount;
1881         }
1882 
1883         _mint(msg.sender, amount);
1884     }
1885 
1886 
1887     function WL3FM_MINT(uint256 amount, bytes32[] memory proof) external {
1888         require(isWhiteLists3(proof, keccak256(abi.encodePacked(msg.sender))),"not WL3");
1889         require(minteds3 + amount <= WL3FM_MAX_SUPPLY, "Sold out!");
1890         require(minteds3Map[msg.sender] + amount <= WL3FM_LIMIT, "Limit exceeded");
1891         require(block.timestamp >= WL_SaleTime, "Not on WL sale");
1892         require(PUB_SaleTime >= block.timestamp , "Not on WL sale");
1893         unchecked {
1894             minteds3Map[msg.sender] += amount;
1895             minteds3 += amount;
1896         }
1897 
1898         _mint(msg.sender, amount);
1899     }
1900 
1901     function PUB_MINT(uint256 amount) external payable {
1902         require(totalSupply() + amount <= MAX_SUPPLY, "Sold out!");
1903         require(minteds4Map[msg.sender] + amount <= PUB_LIMIT, "Limit exceeded");
1904         require(msg.value >= amount* PUB_PRICE,"value low");
1905         require(block.timestamp >= PUB_SaleTime, "Not on PUB sale");
1906         unchecked {
1907             minteds4Map[msg.sender] += amount;
1908             minteds4 += amount;
1909         }
1910         _mint(msg.sender, amount);
1911     }
1912 
1913     function isWhiteLists1(bytes32[] memory proof, bytes32 leaf)
1914         public
1915         view
1916         returns (bool)
1917     {
1918         return MerkleProof.verify(proof, root1, leaf);
1919     }
1920 
1921     function isWhiteLists2(bytes32[] memory proof, bytes32 leaf)
1922         public
1923         view
1924         returns (bool)
1925     {
1926         return MerkleProof.verify(proof, root2, leaf);
1927     }
1928 
1929     function isWhiteLists3(bytes32[] memory proof, bytes32 leaf)
1930         public
1931         view
1932         returns (bool)
1933     {
1934         return MerkleProof.verify(proof, root3, leaf);
1935     }
1936 
1937     receive() external payable {}
1938 
1939     function ownerMint(address to, uint256 amount) external onlyOwner {
1940         require(totalSupply() + amount <= MAX_SUPPLY, "Sold out!");
1941         _mint(to, amount);
1942     }
1943 
1944     function setBaseTokenURI(string calldata _uri) external onlyOwner {
1945         baseTokenURI = _uri;
1946     }
1947 
1948     function setMetadata(address _address) external onlyOwner {
1949         metaDataAddress = _address;
1950     }
1951 
1952     function setDisapprovedMarketplace(address market, bool isDisapprove)
1953         external
1954         onlyOwner
1955     {
1956         disapprovedMarketplaces[market] = isDisapprove;
1957     }
1958 
1959     function approve(address to, uint256 tokenId)
1960         public
1961         payable
1962         virtual
1963         override
1964     {
1965         require(!disapprovedMarketplaces[to], "The address is not approved");
1966         super.approve(to, tokenId);
1967     }
1968 
1969     function setApprovalForAll(address operator, bool approved)
1970         public
1971         virtual
1972         override
1973     {
1974         require(
1975             !disapprovedMarketplaces[operator],
1976             "The address is not approved"
1977         );
1978         super.setApprovalForAll(operator, approved);
1979     }
1980 
1981     function _baseURI() internal view override returns (string memory) {
1982         return baseTokenURI;
1983     }
1984 
1985     function tokenURI(uint256 tokenId)
1986         public
1987         view
1988         override
1989         returns (string memory)
1990     {
1991         require(
1992             _exists(tokenId),
1993             "ERC721Metadata: URI query for nonexistent token"
1994         );
1995         string memory baseURI = _baseURI();
1996         string memory _tokenUri = IDIOSMetadata(metaDataAddress).getMetadata(tokenId);
1997         return
1998             bytes(baseURI).length != 0
1999                 ? _tokenUri
2000                 : "";
2001     }
2002 
2003     function _startTokenId() internal pure override returns (uint256) {
2004         return 1;
2005     }
2006 
2007     function withdraw() public payable onlyOwner {
2008         (bool success, ) = payable(msg.sender).call{
2009             value: address(this).balance
2010         }("");
2011         require(success);
2012     }
2013 }
2014 
2015 interface IDIOSMetadata {
2016     function getMetadata(uint256 tokenId) external view returns (string memory);    
2017 }