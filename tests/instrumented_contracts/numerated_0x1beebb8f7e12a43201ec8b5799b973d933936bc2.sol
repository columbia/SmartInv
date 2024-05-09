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
411 // File: @openzeppelin/contracts/security/Pausable.sol
412 
413 
414 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 
419 /**
420  * @dev Contract module which allows children to implement an emergency stop
421  * mechanism that can be triggered by an authorized account.
422  *
423  * This module is used through inheritance. It will make available the
424  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
425  * the functions of your contract. Note that they will not be pausable by
426  * simply including this module, only once the modifiers are put in place.
427  */
428 abstract contract Pausable is Context {
429     /**
430      * @dev Emitted when the pause is triggered by `account`.
431      */
432     event Paused(address account);
433 
434     /**
435      * @dev Emitted when the pause is lifted by `account`.
436      */
437     event Unpaused(address account);
438 
439     bool private _paused;
440 
441     /**
442      * @dev Initializes the contract in unpaused state.
443      */
444     constructor() {
445         _paused = false;
446     }
447 
448     /**
449      * @dev Modifier to make a function callable only when the contract is not paused.
450      *
451      * Requirements:
452      *
453      * - The contract must not be paused.
454      */
455     modifier whenNotPaused() {
456         _requireNotPaused();
457         _;
458     }
459 
460     /**
461      * @dev Modifier to make a function callable only when the contract is paused.
462      *
463      * Requirements:
464      *
465      * - The contract must be paused.
466      */
467     modifier whenPaused() {
468         _requirePaused();
469         _;
470     }
471 
472     /**
473      * @dev Returns true if the contract is paused, and false otherwise.
474      */
475     function paused() public view virtual returns (bool) {
476         return _paused;
477     }
478 
479     /**
480      * @dev Throws if the contract is paused.
481      */
482     function _requireNotPaused() internal view virtual {
483         require(!paused(), "Pausable: paused");
484     }
485 
486     /**
487      * @dev Throws if the contract is not paused.
488      */
489     function _requirePaused() internal view virtual {
490         require(paused(), "Pausable: not paused");
491     }
492 
493     /**
494      * @dev Triggers stopped state.
495      *
496      * Requirements:
497      *
498      * - The contract must not be paused.
499      */
500     function _pause() internal virtual whenNotPaused {
501         _paused = true;
502         emit Paused(_msgSender());
503     }
504 
505     /**
506      * @dev Returns to normal state.
507      *
508      * Requirements:
509      *
510      * - The contract must be paused.
511      */
512     function _unpause() internal virtual whenPaused {
513         _paused = false;
514         emit Unpaused(_msgSender());
515     }
516 }
517 
518 // File: erc721a/contracts/IERC721A.sol
519 
520 
521 // ERC721A Contracts v4.2.3
522 // Creator: Chiru Labs
523 
524 pragma solidity ^0.8.4;
525 
526 /**
527  * @dev Interface of ERC721A.
528  */
529 interface IERC721A {
530     /**
531      * The caller must own the token or be an approved operator.
532      */
533     error ApprovalCallerNotOwnerNorApproved();
534 
535     /**
536      * The token does not exist.
537      */
538     error ApprovalQueryForNonexistentToken();
539 
540     /**
541      * Cannot query the balance for the zero address.
542      */
543     error BalanceQueryForZeroAddress();
544 
545     /**
546      * Cannot mint to the zero address.
547      */
548     error MintToZeroAddress();
549 
550     /**
551      * The quantity of tokens minted must be more than zero.
552      */
553     error MintZeroQuantity();
554 
555     /**
556      * The token does not exist.
557      */
558     error OwnerQueryForNonexistentToken();
559 
560     /**
561      * The caller must own the token or be an approved operator.
562      */
563     error TransferCallerNotOwnerNorApproved();
564 
565     /**
566      * The token must be owned by `from`.
567      */
568     error TransferFromIncorrectOwner();
569 
570     /**
571      * Cannot safely transfer to a contract that does not implement the
572      * ERC721Receiver interface.
573      */
574     error TransferToNonERC721ReceiverImplementer();
575 
576     /**
577      * Cannot transfer to the zero address.
578      */
579     error TransferToZeroAddress();
580 
581     /**
582      * The token does not exist.
583      */
584     error URIQueryForNonexistentToken();
585 
586     /**
587      * The `quantity` minted with ERC2309 exceeds the safety limit.
588      */
589     error MintERC2309QuantityExceedsLimit();
590 
591     /**
592      * The `extraData` cannot be set on an unintialized ownership slot.
593      */
594     error OwnershipNotInitializedForExtraData();
595 
596     // =============================================================
597     //                            STRUCTS
598     // =============================================================
599 
600     struct TokenOwnership {
601         // The address of the owner.
602         address addr;
603         // Stores the start time of ownership with minimal overhead for tokenomics.
604         uint64 startTimestamp;
605         // Whether the token has been burned.
606         bool burned;
607         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
608         uint24 extraData;
609     }
610 
611     // =============================================================
612     //                         TOKEN COUNTERS
613     // =============================================================
614 
615     /**
616      * @dev Returns the total number of tokens in existence.
617      * Burned tokens will reduce the count.
618      * To get the total number of tokens minted, please see {_totalMinted}.
619      */
620     function totalSupply() external view returns (uint256);
621 
622     // =============================================================
623     //                            IERC165
624     // =============================================================
625 
626     /**
627      * @dev Returns true if this contract implements the interface defined by
628      * `interfaceId`. See the corresponding
629      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
630      * to learn more about how these ids are created.
631      *
632      * This function call must use less than 30000 gas.
633      */
634     function supportsInterface(bytes4 interfaceId) external view returns (bool);
635 
636     // =============================================================
637     //                            IERC721
638     // =============================================================
639 
640     /**
641      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
642      */
643     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
644 
645     /**
646      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
647      */
648     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
649 
650     /**
651      * @dev Emitted when `owner` enables or disables
652      * (`approved`) `operator` to manage all of its assets.
653      */
654     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
655 
656     /**
657      * @dev Returns the number of tokens in `owner`'s account.
658      */
659     function balanceOf(address owner) external view returns (uint256 balance);
660 
661     /**
662      * @dev Returns the owner of the `tokenId` token.
663      *
664      * Requirements:
665      *
666      * - `tokenId` must exist.
667      */
668     function ownerOf(uint256 tokenId) external view returns (address owner);
669 
670     /**
671      * @dev Safely transfers `tokenId` token from `from` to `to`,
672      * checking first that contract recipients are aware of the ERC721 protocol
673      * to prevent tokens from being forever locked.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must exist and be owned by `from`.
680      * - If the caller is not `from`, it must be have been allowed to move
681      * this token by either {approve} or {setApprovalForAll}.
682      * - If `to` refers to a smart contract, it must implement
683      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
684      *
685      * Emits a {Transfer} event.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId,
691         bytes calldata data
692     ) external payable;
693 
694     /**
695      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
696      */
697     function safeTransferFrom(
698         address from,
699         address to,
700         uint256 tokenId
701     ) external payable;
702 
703     /**
704      * @dev Transfers `tokenId` from `from` to `to`.
705      *
706      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
707      * whenever possible.
708      *
709      * Requirements:
710      *
711      * - `from` cannot be the zero address.
712      * - `to` cannot be the zero address.
713      * - `tokenId` token must be owned by `from`.
714      * - If the caller is not `from`, it must be approved to move this token
715      * by either {approve} or {setApprovalForAll}.
716      *
717      * Emits a {Transfer} event.
718      */
719     function transferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) external payable;
724 
725     /**
726      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
727      * The approval is cleared when the token is transferred.
728      *
729      * Only a single account can be approved at a time, so approving the
730      * zero address clears previous approvals.
731      *
732      * Requirements:
733      *
734      * - The caller must own the token or be an approved operator.
735      * - `tokenId` must exist.
736      *
737      * Emits an {Approval} event.
738      */
739     function approve(address to, uint256 tokenId) external payable;
740 
741     /**
742      * @dev Approve or remove `operator` as an operator for the caller.
743      * Operators can call {transferFrom} or {safeTransferFrom}
744      * for any token owned by the caller.
745      *
746      * Requirements:
747      *
748      * - The `operator` cannot be the caller.
749      *
750      * Emits an {ApprovalForAll} event.
751      */
752     function setApprovalForAll(address operator, bool _approved) external;
753 
754     /**
755      * @dev Returns the account approved for `tokenId` token.
756      *
757      * Requirements:
758      *
759      * - `tokenId` must exist.
760      */
761     function getApproved(uint256 tokenId) external view returns (address operator);
762 
763     /**
764      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
765      *
766      * See {setApprovalForAll}.
767      */
768     function isApprovedForAll(address owner, address operator) external view returns (bool);
769 
770     // =============================================================
771     //                        IERC721Metadata
772     // =============================================================
773 
774     /**
775      * @dev Returns the token collection name.
776      */
777     function name() external view returns (string memory);
778 
779     /**
780      * @dev Returns the token collection symbol.
781      */
782     function symbol() external view returns (string memory);
783 
784     /**
785      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
786      */
787     function tokenURI(uint256 tokenId) external view returns (string memory);
788 
789     // =============================================================
790     //                           IERC2309
791     // =============================================================
792 
793     /**
794      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
795      * (inclusive) is transferred from `from` to `to`, as defined in the
796      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
797      *
798      * See {_mintERC2309} for more details.
799      */
800     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
801 }
802 
803 // File: erc721a/contracts/ERC721A.sol
804 
805 
806 // ERC721A Contracts v4.2.3
807 // Creator: Chiru Labs
808 
809 pragma solidity ^0.8.4;
810 
811 
812 /**
813  * @dev Interface of ERC721 token receiver.
814  */
815 interface ERC721A__IERC721Receiver {
816     function onERC721Received(
817         address operator,
818         address from,
819         uint256 tokenId,
820         bytes calldata data
821     ) external returns (bytes4);
822 }
823 
824 /**
825  * @title ERC721A
826  *
827  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
828  * Non-Fungible Token Standard, including the Metadata extension.
829  * Optimized for lower gas during batch mints.
830  *
831  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
832  * starting from `_startTokenId()`.
833  *
834  * Assumptions:
835  *
836  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
837  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
838  */
839 contract ERC721A is IERC721A {
840     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
841     struct TokenApprovalRef {
842         address value;
843     }
844 
845     // =============================================================
846     //                           CONSTANTS
847     // =============================================================
848 
849     // Mask of an entry in packed address data.
850     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
851 
852     // The bit position of `numberMinted` in packed address data.
853     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
854 
855     // The bit position of `numberBurned` in packed address data.
856     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
857 
858     // The bit position of `aux` in packed address data.
859     uint256 private constant _BITPOS_AUX = 192;
860 
861     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
862     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
863 
864     // The bit position of `startTimestamp` in packed ownership.
865     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
866 
867     // The bit mask of the `burned` bit in packed ownership.
868     uint256 private constant _BITMASK_BURNED = 1 << 224;
869 
870     // The bit position of the `nextInitialized` bit in packed ownership.
871     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
872 
873     // The bit mask of the `nextInitialized` bit in packed ownership.
874     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
875 
876     // The bit position of `extraData` in packed ownership.
877     uint256 private constant _BITPOS_EXTRA_DATA = 232;
878 
879     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
880     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
881 
882     // The mask of the lower 160 bits for addresses.
883     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
884 
885     // The maximum `quantity` that can be minted with {_mintERC2309}.
886     // This limit is to prevent overflows on the address data entries.
887     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
888     // is required to cause an overflow, which is unrealistic.
889     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
890 
891     // The `Transfer` event signature is given by:
892     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
893     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
894         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
895 
896     // =============================================================
897     //                            STORAGE
898     // =============================================================
899 
900     // The next token ID to be minted.
901     uint256 private _currentIndex;
902 
903     // The number of tokens burned.
904     uint256 private _burnCounter;
905 
906     // Token name
907     string private _name;
908 
909     // Token symbol
910     string private _symbol;
911 
912     // Mapping from token ID to ownership details
913     // An empty struct value does not necessarily mean the token is unowned.
914     // See {_packedOwnershipOf} implementation for details.
915     //
916     // Bits Layout:
917     // - [0..159]   `addr`
918     // - [160..223] `startTimestamp`
919     // - [224]      `burned`
920     // - [225]      `nextInitialized`
921     // - [232..255] `extraData`
922     mapping(uint256 => uint256) private _packedOwnerships;
923 
924     // Mapping owner address to address data.
925     //
926     // Bits Layout:
927     // - [0..63]    `balance`
928     // - [64..127]  `numberMinted`
929     // - [128..191] `numberBurned`
930     // - [192..255] `aux`
931     mapping(address => uint256) private _packedAddressData;
932 
933     // Mapping from token ID to approved address.
934     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
935 
936     // Mapping from owner to operator approvals
937     mapping(address => mapping(address => bool)) private _operatorApprovals;
938 
939     // =============================================================
940     //                          CONSTRUCTOR
941     // =============================================================
942 
943     constructor(string memory name_, string memory symbol_) {
944         _name = name_;
945         _symbol = symbol_;
946         _currentIndex = _startTokenId();
947     }
948 
949     // =============================================================
950     //                   TOKEN COUNTING OPERATIONS
951     // =============================================================
952 
953     /**
954      * @dev Returns the starting token ID.
955      * To change the starting token ID, please override this function.
956      */
957     function _startTokenId() internal view virtual returns (uint256) {
958         return 0;
959     }
960 
961     /**
962      * @dev Returns the next token ID to be minted.
963      */
964     function _nextTokenId() internal view virtual returns (uint256) {
965         return _currentIndex;
966     }
967 
968     /**
969      * @dev Returns the total number of tokens in existence.
970      * Burned tokens will reduce the count.
971      * To get the total number of tokens minted, please see {_totalMinted}.
972      */
973     function totalSupply() public view virtual override returns (uint256) {
974         // Counter underflow is impossible as _burnCounter cannot be incremented
975         // more than `_currentIndex - _startTokenId()` times.
976         unchecked {
977             return _currentIndex - _burnCounter - _startTokenId();
978         }
979     }
980 
981     /**
982      * @dev Returns the total amount of tokens minted in the contract.
983      */
984     function _totalMinted() internal view virtual returns (uint256) {
985         // Counter underflow is impossible as `_currentIndex` does not decrement,
986         // and it is initialized to `_startTokenId()`.
987         unchecked {
988             return _currentIndex - _startTokenId();
989         }
990     }
991 
992     /**
993      * @dev Returns the total number of tokens burned.
994      */
995     function _totalBurned() internal view virtual returns (uint256) {
996         return _burnCounter;
997     }
998 
999     // =============================================================
1000     //                    ADDRESS DATA OPERATIONS
1001     // =============================================================
1002 
1003     /**
1004      * @dev Returns the number of tokens in `owner`'s account.
1005      */
1006     function balanceOf(address owner) public view virtual override returns (uint256) {
1007         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1008         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1009     }
1010 
1011     /**
1012      * Returns the number of tokens minted by `owner`.
1013      */
1014     function _numberMinted(address owner) internal view returns (uint256) {
1015         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1016     }
1017 
1018     /**
1019      * Returns the number of tokens burned by or on behalf of `owner`.
1020      */
1021     function _numberBurned(address owner) internal view returns (uint256) {
1022         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1023     }
1024 
1025     /**
1026      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1027      */
1028     function _getAux(address owner) internal view returns (uint64) {
1029         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1030     }
1031 
1032     /**
1033      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1034      * If there are multiple variables, please pack them into a uint64.
1035      */
1036     function _setAux(address owner, uint64 aux) internal virtual {
1037         uint256 packed = _packedAddressData[owner];
1038         uint256 auxCasted;
1039         // Cast `aux` with assembly to avoid redundant masking.
1040         assembly {
1041             auxCasted := aux
1042         }
1043         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1044         _packedAddressData[owner] = packed;
1045     }
1046 
1047     // =============================================================
1048     //                            IERC165
1049     // =============================================================
1050 
1051     /**
1052      * @dev Returns true if this contract implements the interface defined by
1053      * `interfaceId`. See the corresponding
1054      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1055      * to learn more about how these ids are created.
1056      *
1057      * This function call must use less than 30000 gas.
1058      */
1059     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1060         // The interface IDs are constants representing the first 4 bytes
1061         // of the XOR of all function selectors in the interface.
1062         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1063         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1064         return
1065             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1066             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1067             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1068     }
1069 
1070     // =============================================================
1071     //                        IERC721Metadata
1072     // =============================================================
1073 
1074     /**
1075      * @dev Returns the token collection name.
1076      */
1077     function name() public view virtual override returns (string memory) {
1078         return _name;
1079     }
1080 
1081     /**
1082      * @dev Returns the token collection symbol.
1083      */
1084     function symbol() public view virtual override returns (string memory) {
1085         return _symbol;
1086     }
1087 
1088     /**
1089      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1090      */
1091     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1092         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1093 
1094         string memory baseURI = _baseURI();
1095         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1096     }
1097 
1098     /**
1099      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1100      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1101      * by default, it can be overridden in child contracts.
1102      */
1103     function _baseURI() internal view virtual returns (string memory) {
1104         return '';
1105     }
1106 
1107     // =============================================================
1108     //                     OWNERSHIPS OPERATIONS
1109     // =============================================================
1110 
1111     /**
1112      * @dev Returns the owner of the `tokenId` token.
1113      *
1114      * Requirements:
1115      *
1116      * - `tokenId` must exist.
1117      */
1118     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1119         return address(uint160(_packedOwnershipOf(tokenId)));
1120     }
1121 
1122     /**
1123      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1124      * It gradually moves to O(1) as tokens get transferred around over time.
1125      */
1126     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1127         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1128     }
1129 
1130     /**
1131      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1132      */
1133     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1134         return _unpackedOwnership(_packedOwnerships[index]);
1135     }
1136 
1137     /**
1138      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1139      */
1140     function _initializeOwnershipAt(uint256 index) internal virtual {
1141         if (_packedOwnerships[index] == 0) {
1142             _packedOwnerships[index] = _packedOwnershipOf(index);
1143         }
1144     }
1145 
1146     /**
1147      * Returns the packed ownership data of `tokenId`.
1148      */
1149     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1150         uint256 curr = tokenId;
1151 
1152         unchecked {
1153             if (_startTokenId() <= curr)
1154                 if (curr < _currentIndex) {
1155                     uint256 packed = _packedOwnerships[curr];
1156                     // If not burned.
1157                     if (packed & _BITMASK_BURNED == 0) {
1158                         // Invariant:
1159                         // There will always be an initialized ownership slot
1160                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1161                         // before an unintialized ownership slot
1162                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1163                         // Hence, `curr` will not underflow.
1164                         //
1165                         // We can directly compare the packed value.
1166                         // If the address is zero, packed will be zero.
1167                         while (packed == 0) {
1168                             packed = _packedOwnerships[--curr];
1169                         }
1170                         return packed;
1171                     }
1172                 }
1173         }
1174         revert OwnerQueryForNonexistentToken();
1175     }
1176 
1177     /**
1178      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1179      */
1180     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1181         ownership.addr = address(uint160(packed));
1182         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1183         ownership.burned = packed & _BITMASK_BURNED != 0;
1184         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1185     }
1186 
1187     /**
1188      * @dev Packs ownership data into a single uint256.
1189      */
1190     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1191         assembly {
1192             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1193             owner := and(owner, _BITMASK_ADDRESS)
1194             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1195             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1196         }
1197     }
1198 
1199     /**
1200      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1201      */
1202     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1203         // For branchless setting of the `nextInitialized` flag.
1204         assembly {
1205             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1206             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1207         }
1208     }
1209 
1210     // =============================================================
1211     //                      APPROVAL OPERATIONS
1212     // =============================================================
1213 
1214     /**
1215      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1216      * The approval is cleared when the token is transferred.
1217      *
1218      * Only a single account can be approved at a time, so approving the
1219      * zero address clears previous approvals.
1220      *
1221      * Requirements:
1222      *
1223      * - The caller must own the token or be an approved operator.
1224      * - `tokenId` must exist.
1225      *
1226      * Emits an {Approval} event.
1227      */
1228     function approve(address to, uint256 tokenId) public payable virtual override {
1229         address owner = ownerOf(tokenId);
1230 
1231         if (_msgSenderERC721A() != owner)
1232             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1233                 revert ApprovalCallerNotOwnerNorApproved();
1234             }
1235 
1236         _tokenApprovals[tokenId].value = to;
1237         emit Approval(owner, to, tokenId);
1238     }
1239 
1240     /**
1241      * @dev Returns the account approved for `tokenId` token.
1242      *
1243      * Requirements:
1244      *
1245      * - `tokenId` must exist.
1246      */
1247     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1248         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1249 
1250         return _tokenApprovals[tokenId].value;
1251     }
1252 
1253     /**
1254      * @dev Approve or remove `operator` as an operator for the caller.
1255      * Operators can call {transferFrom} or {safeTransferFrom}
1256      * for any token owned by the caller.
1257      *
1258      * Requirements:
1259      *
1260      * - The `operator` cannot be the caller.
1261      *
1262      * Emits an {ApprovalForAll} event.
1263      */
1264     function setApprovalForAll(address operator, bool approved) public virtual override {
1265         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1266         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1267     }
1268 
1269     /**
1270      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1271      *
1272      * See {setApprovalForAll}.
1273      */
1274     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1275         return _operatorApprovals[owner][operator];
1276     }
1277 
1278     /**
1279      * @dev Returns whether `tokenId` exists.
1280      *
1281      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1282      *
1283      * Tokens start existing when they are minted. See {_mint}.
1284      */
1285     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1286         return
1287             _startTokenId() <= tokenId &&
1288             tokenId < _currentIndex && // If within bounds,
1289             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1290     }
1291 
1292     /**
1293      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1294      */
1295     function _isSenderApprovedOrOwner(
1296         address approvedAddress,
1297         address owner,
1298         address msgSender
1299     ) private pure returns (bool result) {
1300         assembly {
1301             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1302             owner := and(owner, _BITMASK_ADDRESS)
1303             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1304             msgSender := and(msgSender, _BITMASK_ADDRESS)
1305             // `msgSender == owner || msgSender == approvedAddress`.
1306             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1307         }
1308     }
1309 
1310     /**
1311      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1312      */
1313     function _getApprovedSlotAndAddress(uint256 tokenId)
1314         private
1315         view
1316         returns (uint256 approvedAddressSlot, address approvedAddress)
1317     {
1318         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1319         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1320         assembly {
1321             approvedAddressSlot := tokenApproval.slot
1322             approvedAddress := sload(approvedAddressSlot)
1323         }
1324     }
1325 
1326     // =============================================================
1327     //                      TRANSFER OPERATIONS
1328     // =============================================================
1329 
1330     /**
1331      * @dev Transfers `tokenId` from `from` to `to`.
1332      *
1333      * Requirements:
1334      *
1335      * - `from` cannot be the zero address.
1336      * - `to` cannot be the zero address.
1337      * - `tokenId` token must be owned by `from`.
1338      * - If the caller is not `from`, it must be approved to move this token
1339      * by either {approve} or {setApprovalForAll}.
1340      *
1341      * Emits a {Transfer} event.
1342      */
1343     function transferFrom(
1344         address from,
1345         address to,
1346         uint256 tokenId
1347     ) public payable virtual override {
1348         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1349 
1350         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1351 
1352         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1353 
1354         // The nested ifs save around 20+ gas over a compound boolean condition.
1355         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1356             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1357 
1358         if (to == address(0)) revert TransferToZeroAddress();
1359 
1360         _beforeTokenTransfers(from, to, tokenId, 1);
1361 
1362         // Clear approvals from the previous owner.
1363         assembly {
1364             if approvedAddress {
1365                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1366                 sstore(approvedAddressSlot, 0)
1367             }
1368         }
1369 
1370         // Underflow of the sender's balance is impossible because we check for
1371         // ownership above and the recipient's balance can't realistically overflow.
1372         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1373         unchecked {
1374             // We can directly increment and decrement the balances.
1375             --_packedAddressData[from]; // Updates: `balance -= 1`.
1376             ++_packedAddressData[to]; // Updates: `balance += 1`.
1377 
1378             // Updates:
1379             // - `address` to the next owner.
1380             // - `startTimestamp` to the timestamp of transfering.
1381             // - `burned` to `false`.
1382             // - `nextInitialized` to `true`.
1383             _packedOwnerships[tokenId] = _packOwnershipData(
1384                 to,
1385                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1386             );
1387 
1388             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1389             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1390                 uint256 nextTokenId = tokenId + 1;
1391                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1392                 if (_packedOwnerships[nextTokenId] == 0) {
1393                     // If the next slot is within bounds.
1394                     if (nextTokenId != _currentIndex) {
1395                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1396                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1397                     }
1398                 }
1399             }
1400         }
1401 
1402         emit Transfer(from, to, tokenId);
1403         _afterTokenTransfers(from, to, tokenId, 1);
1404     }
1405 
1406     /**
1407      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1408      */
1409     function safeTransferFrom(
1410         address from,
1411         address to,
1412         uint256 tokenId
1413     ) public payable virtual override {
1414         safeTransferFrom(from, to, tokenId, '');
1415     }
1416 
1417     /**
1418      * @dev Safely transfers `tokenId` token from `from` to `to`.
1419      *
1420      * Requirements:
1421      *
1422      * - `from` cannot be the zero address.
1423      * - `to` cannot be the zero address.
1424      * - `tokenId` token must exist and be owned by `from`.
1425      * - If the caller is not `from`, it must be approved to move this token
1426      * by either {approve} or {setApprovalForAll}.
1427      * - If `to` refers to a smart contract, it must implement
1428      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1429      *
1430      * Emits a {Transfer} event.
1431      */
1432     function safeTransferFrom(
1433         address from,
1434         address to,
1435         uint256 tokenId,
1436         bytes memory _data
1437     ) public payable virtual override {
1438         transferFrom(from, to, tokenId);
1439         if (to.code.length != 0)
1440             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1441                 revert TransferToNonERC721ReceiverImplementer();
1442             }
1443     }
1444 
1445     /**
1446      * @dev Hook that is called before a set of serially-ordered token IDs
1447      * are about to be transferred. This includes minting.
1448      * And also called before burning one token.
1449      *
1450      * `startTokenId` - the first token ID to be transferred.
1451      * `quantity` - the amount to be transferred.
1452      *
1453      * Calling conditions:
1454      *
1455      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1456      * transferred to `to`.
1457      * - When `from` is zero, `tokenId` will be minted for `to`.
1458      * - When `to` is zero, `tokenId` will be burned by `from`.
1459      * - `from` and `to` are never both zero.
1460      */
1461     function _beforeTokenTransfers(
1462         address from,
1463         address to,
1464         uint256 startTokenId,
1465         uint256 quantity
1466     ) internal virtual {}
1467 
1468     /**
1469      * @dev Hook that is called after a set of serially-ordered token IDs
1470      * have been transferred. This includes minting.
1471      * And also called after one token has been burned.
1472      *
1473      * `startTokenId` - the first token ID to be transferred.
1474      * `quantity` - the amount to be transferred.
1475      *
1476      * Calling conditions:
1477      *
1478      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1479      * transferred to `to`.
1480      * - When `from` is zero, `tokenId` has been minted for `to`.
1481      * - When `to` is zero, `tokenId` has been burned by `from`.
1482      * - `from` and `to` are never both zero.
1483      */
1484     function _afterTokenTransfers(
1485         address from,
1486         address to,
1487         uint256 startTokenId,
1488         uint256 quantity
1489     ) internal virtual {}
1490 
1491     /**
1492      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1493      *
1494      * `from` - Previous owner of the given token ID.
1495      * `to` - Target address that will receive the token.
1496      * `tokenId` - Token ID to be transferred.
1497      * `_data` - Optional data to send along with the call.
1498      *
1499      * Returns whether the call correctly returned the expected magic value.
1500      */
1501     function _checkContractOnERC721Received(
1502         address from,
1503         address to,
1504         uint256 tokenId,
1505         bytes memory _data
1506     ) private returns (bool) {
1507         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1508             bytes4 retval
1509         ) {
1510             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1511         } catch (bytes memory reason) {
1512             if (reason.length == 0) {
1513                 revert TransferToNonERC721ReceiverImplementer();
1514             } else {
1515                 assembly {
1516                     revert(add(32, reason), mload(reason))
1517                 }
1518             }
1519         }
1520     }
1521 
1522     // =============================================================
1523     //                        MINT OPERATIONS
1524     // =============================================================
1525 
1526     /**
1527      * @dev Mints `quantity` tokens and transfers them to `to`.
1528      *
1529      * Requirements:
1530      *
1531      * - `to` cannot be the zero address.
1532      * - `quantity` must be greater than 0.
1533      *
1534      * Emits a {Transfer} event for each mint.
1535      */
1536     function _mint(address to, uint256 quantity) internal virtual {
1537         uint256 startTokenId = _currentIndex;
1538         if (quantity == 0) revert MintZeroQuantity();
1539 
1540         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1541 
1542         // Overflows are incredibly unrealistic.
1543         // `balance` and `numberMinted` have a maximum limit of 2**64.
1544         // `tokenId` has a maximum limit of 2**256.
1545         unchecked {
1546             // Updates:
1547             // - `balance += quantity`.
1548             // - `numberMinted += quantity`.
1549             //
1550             // We can directly add to the `balance` and `numberMinted`.
1551             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1552 
1553             // Updates:
1554             // - `address` to the owner.
1555             // - `startTimestamp` to the timestamp of minting.
1556             // - `burned` to `false`.
1557             // - `nextInitialized` to `quantity == 1`.
1558             _packedOwnerships[startTokenId] = _packOwnershipData(
1559                 to,
1560                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1561             );
1562 
1563             uint256 toMasked;
1564             uint256 end = startTokenId + quantity;
1565 
1566             // Use assembly to loop and emit the `Transfer` event for gas savings.
1567             // The duplicated `log4` removes an extra check and reduces stack juggling.
1568             // The assembly, together with the surrounding Solidity code, have been
1569             // delicately arranged to nudge the compiler into producing optimized opcodes.
1570             assembly {
1571                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1572                 toMasked := and(to, _BITMASK_ADDRESS)
1573                 // Emit the `Transfer` event.
1574                 log4(
1575                     0, // Start of data (0, since no data).
1576                     0, // End of data (0, since no data).
1577                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1578                     0, // `address(0)`.
1579                     toMasked, // `to`.
1580                     startTokenId // `tokenId`.
1581                 )
1582 
1583                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1584                 // that overflows uint256 will make the loop run out of gas.
1585                 // The compiler will optimize the `iszero` away for performance.
1586                 for {
1587                     let tokenId := add(startTokenId, 1)
1588                 } iszero(eq(tokenId, end)) {
1589                     tokenId := add(tokenId, 1)
1590                 } {
1591                     // Emit the `Transfer` event. Similar to above.
1592                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1593                 }
1594             }
1595             if (toMasked == 0) revert MintToZeroAddress();
1596 
1597             _currentIndex = end;
1598         }
1599         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1600     }
1601 
1602     /**
1603      * @dev Mints `quantity` tokens and transfers them to `to`.
1604      *
1605      * This function is intended for efficient minting only during contract creation.
1606      *
1607      * It emits only one {ConsecutiveTransfer} as defined in
1608      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1609      * instead of a sequence of {Transfer} event(s).
1610      *
1611      * Calling this function outside of contract creation WILL make your contract
1612      * non-compliant with the ERC721 standard.
1613      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1614      * {ConsecutiveTransfer} event is only permissible during contract creation.
1615      *
1616      * Requirements:
1617      *
1618      * - `to` cannot be the zero address.
1619      * - `quantity` must be greater than 0.
1620      *
1621      * Emits a {ConsecutiveTransfer} event.
1622      */
1623     function _mintERC2309(address to, uint256 quantity) internal virtual {
1624         uint256 startTokenId = _currentIndex;
1625         if (to == address(0)) revert MintToZeroAddress();
1626         if (quantity == 0) revert MintZeroQuantity();
1627         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1628 
1629         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1630 
1631         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1632         unchecked {
1633             // Updates:
1634             // - `balance += quantity`.
1635             // - `numberMinted += quantity`.
1636             //
1637             // We can directly add to the `balance` and `numberMinted`.
1638             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1639 
1640             // Updates:
1641             // - `address` to the owner.
1642             // - `startTimestamp` to the timestamp of minting.
1643             // - `burned` to `false`.
1644             // - `nextInitialized` to `quantity == 1`.
1645             _packedOwnerships[startTokenId] = _packOwnershipData(
1646                 to,
1647                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1648             );
1649 
1650             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1651 
1652             _currentIndex = startTokenId + quantity;
1653         }
1654         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1655     }
1656 
1657     /**
1658      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1659      *
1660      * Requirements:
1661      *
1662      * - If `to` refers to a smart contract, it must implement
1663      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1664      * - `quantity` must be greater than 0.
1665      *
1666      * See {_mint}.
1667      *
1668      * Emits a {Transfer} event for each mint.
1669      */
1670     function _safeMint(
1671         address to,
1672         uint256 quantity,
1673         bytes memory _data
1674     ) internal virtual {
1675         _mint(to, quantity);
1676 
1677         unchecked {
1678             if (to.code.length != 0) {
1679                 uint256 end = _currentIndex;
1680                 uint256 index = end - quantity;
1681                 do {
1682                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1683                         revert TransferToNonERC721ReceiverImplementer();
1684                     }
1685                 } while (index < end);
1686                 // Reentrancy protection.
1687                 if (_currentIndex != end) revert();
1688             }
1689         }
1690     }
1691 
1692     /**
1693      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1694      */
1695     function _safeMint(address to, uint256 quantity) internal virtual {
1696         _safeMint(to, quantity, '');
1697     }
1698 
1699     // =============================================================
1700     //                        BURN OPERATIONS
1701     // =============================================================
1702 
1703     /**
1704      * @dev Equivalent to `_burn(tokenId, false)`.
1705      */
1706     function _burn(uint256 tokenId) internal virtual {
1707         _burn(tokenId, false);
1708     }
1709 
1710     /**
1711      * @dev Destroys `tokenId`.
1712      * The approval is cleared when the token is burned.
1713      *
1714      * Requirements:
1715      *
1716      * - `tokenId` must exist.
1717      *
1718      * Emits a {Transfer} event.
1719      */
1720     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1721         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1722 
1723         address from = address(uint160(prevOwnershipPacked));
1724 
1725         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1726 
1727         if (approvalCheck) {
1728             // The nested ifs save around 20+ gas over a compound boolean condition.
1729             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1730                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1731         }
1732 
1733         _beforeTokenTransfers(from, address(0), tokenId, 1);
1734 
1735         // Clear approvals from the previous owner.
1736         assembly {
1737             if approvedAddress {
1738                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1739                 sstore(approvedAddressSlot, 0)
1740             }
1741         }
1742 
1743         // Underflow of the sender's balance is impossible because we check for
1744         // ownership above and the recipient's balance can't realistically overflow.
1745         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1746         unchecked {
1747             // Updates:
1748             // - `balance -= 1`.
1749             // - `numberBurned += 1`.
1750             //
1751             // We can directly decrement the balance, and increment the number burned.
1752             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1753             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1754 
1755             // Updates:
1756             // - `address` to the last owner.
1757             // - `startTimestamp` to the timestamp of burning.
1758             // - `burned` to `true`.
1759             // - `nextInitialized` to `true`.
1760             _packedOwnerships[tokenId] = _packOwnershipData(
1761                 from,
1762                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1763             );
1764 
1765             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1766             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1767                 uint256 nextTokenId = tokenId + 1;
1768                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1769                 if (_packedOwnerships[nextTokenId] == 0) {
1770                     // If the next slot is within bounds.
1771                     if (nextTokenId != _currentIndex) {
1772                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1773                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1774                     }
1775                 }
1776             }
1777         }
1778 
1779         emit Transfer(from, address(0), tokenId);
1780         _afterTokenTransfers(from, address(0), tokenId, 1);
1781 
1782         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1783         unchecked {
1784             _burnCounter++;
1785         }
1786     }
1787 
1788     // =============================================================
1789     //                     EXTRA DATA OPERATIONS
1790     // =============================================================
1791 
1792     /**
1793      * @dev Directly sets the extra data for the ownership data `index`.
1794      */
1795     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1796         uint256 packed = _packedOwnerships[index];
1797         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1798         uint256 extraDataCasted;
1799         // Cast `extraData` with assembly to avoid redundant masking.
1800         assembly {
1801             extraDataCasted := extraData
1802         }
1803         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1804         _packedOwnerships[index] = packed;
1805     }
1806 
1807     /**
1808      * @dev Called during each token transfer to set the 24bit `extraData` field.
1809      * Intended to be overridden by the cosumer contract.
1810      *
1811      * `previousExtraData` - the value of `extraData` before transfer.
1812      *
1813      * Calling conditions:
1814      *
1815      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1816      * transferred to `to`.
1817      * - When `from` is zero, `tokenId` will be minted for `to`.
1818      * - When `to` is zero, `tokenId` will be burned by `from`.
1819      * - `from` and `to` are never both zero.
1820      */
1821     function _extraData(
1822         address from,
1823         address to,
1824         uint24 previousExtraData
1825     ) internal view virtual returns (uint24) {}
1826 
1827     /**
1828      * @dev Returns the next extra data for the packed ownership data.
1829      * The returned result is shifted into position.
1830      */
1831     function _nextExtraData(
1832         address from,
1833         address to,
1834         uint256 prevOwnershipPacked
1835     ) private view returns (uint256) {
1836         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1837         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1838     }
1839 
1840     // =============================================================
1841     //                       OTHER OPERATIONS
1842     // =============================================================
1843 
1844     /**
1845      * @dev Returns the message sender (defaults to `msg.sender`).
1846      *
1847      * If you are writing GSN compatible contracts, you need to override this function.
1848      */
1849     function _msgSenderERC721A() internal view virtual returns (address) {
1850         return msg.sender;
1851     }
1852 
1853     /**
1854      * @dev Converts a uint256 to its ASCII string decimal representation.
1855      */
1856     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1857         assembly {
1858             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1859             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1860             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1861             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1862             let m := add(mload(0x40), 0xa0)
1863             // Update the free memory pointer to allocate.
1864             mstore(0x40, m)
1865             // Assign the `str` to the end.
1866             str := sub(m, 0x20)
1867             // Zeroize the slot after the string.
1868             mstore(str, 0)
1869 
1870             // Cache the end of the memory to calculate the length later.
1871             let end := str
1872 
1873             // We write the string from rightmost digit to leftmost digit.
1874             // The following is essentially a do-while loop that also handles the zero case.
1875             // prettier-ignore
1876             for { let temp := value } 1 {} {
1877                 str := sub(str, 1)
1878                 // Write the character to the pointer.
1879                 // The ASCII index of the '0' character is 48.
1880                 mstore8(str, add(48, mod(temp, 10)))
1881                 // Keep dividing `temp` until zero.
1882                 temp := div(temp, 10)
1883                 // prettier-ignore
1884                 if iszero(temp) { break }
1885             }
1886 
1887             let length := sub(end, str)
1888             // Move the pointer 32 bytes leftwards to make room for the length.
1889             str := sub(str, 0x20)
1890             // Store the length.
1891             mstore(str, length)
1892         }
1893     }
1894 }
1895 
1896 // File: contracts/Pepeland.sol
1897 
1898 
1899 
1900 pragma solidity ^0.8.7;
1901 
1902 
1903 
1904 
1905 
1906 
1907 //                                                        ██████╗░███████╗██████╗░███████╗██╗░░░░░░█████╗░███╗░░██╗██████╗░
1908 //                                                        ██╔══██╗██╔════╝██╔══██╗██╔════╝██║░░░░░██╔══██╗████╗░██║██╔══██╗
1909 //                                                        ██████╔╝█████╗░░██████╔╝█████╗░░██║░░░░░███████║██╔██╗██║██║░░██║
1910 //                                                        ██╔═══╝░██╔══╝░░██╔═══╝░██╔══╝░░██║░░░░░██╔══██║██║╚████║██║░░██║
1911 //                                                        ██║░░░░░███████╗██║░░░░░███████╗███████╗██║░░██║██║░╚███║██████╔╝
1912 //                                                        ╚═╝░░░░░╚══════╝╚═╝░░░░░╚══════╝╚══════╝╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░
1913 //
1914 //
1915 //                                                                             ⣿⠿⠋⠀⣂⣒⠚⠛⠿⣿
1916 //                                                                          ⠿⢋⣡⣶⣾⣿⣿⣿⣿⣶⣶⣤⣉⠛⠿⣿⣿⡿⠛⣋⣡⣤⣶⣶⣶⣤⣉⠙
1917 //                                                                        ⣿⡿⢁⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣌⠰⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄
1918 //                                                                       ⣿⠏⣰⣿⣿⣿⣿⣿⣿⡿⠟⣛⣛⣛⣛⡛⠻⢿⣿⣿⣆⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⢻
1919 //                                                                      ⡿⢁⣾⣿⣿⣿⣿⣿⣯⣷⣾⣿⣿⣿⣿⣿⣿⣿⣶⣤⣉⡛⠂⢙⣯⣭⣭⣽⣿⣿⣿⣿⣯⣭⣿⡀⠙
1920 //                                                                     ⡿⢡⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⢛⣛⣛⣛⣛⣟⣳⡄⠹⢿⣿⣿⣿⠿⠿⠿⢿⣛⣛⣻⣟⡶⠦⢀
1921 //                                                                  ⣿⠿⠋⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⡉⠤⠖⠉⠉⢁⡐⣀⣈⠩⠙⠛⠲⠀⠋⣩⠴⣒⠈⠉⠉⢉⣭⣭⠉⠭⠟⠿⠦⠀⠹
1922 //                                                                 ⡿⣡⣴⣿⢸⣿⣿⣿⣿⣿⣿⡿⠟⢉⠄⢐⠍⢀⣠⡴⠊⠤⠁⠀⠈⢻⣿⣷⣶⣦⣤⡄⠐⣛⣥⣴⡶⠋⠄⠀⠀⠈⠃⣾⣶⣤⣅⠀
1923 //                                                                ⠟⣱⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠠⠔⠀⣠⣶⣿⣿⠁⠀⠄⠀⠛⠀⠀⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⠀⠀⠄⠀⠃⠀⠀⣸⣿⣿⣿⡦
1924 //                                                                ⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⢉⠻⣿⣿⡄⠀⠀⠀⠀⠀⢰⣿⣿⣿⠿⠛⠁⠾⣿⣿⣿⣇⡀⠀⠀⠀⢀⣴⣿⠿⠟⠉⠀
1925 //                                                              ⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣅⡀⠉⠉⠑⠒⠒⠒⠒⢋⡉⠉⠁⣀⣠⣴⣶⣶⣦⣭⣭⣵⣶⣷⣶⣥⣶⣶⡶⠈⢁
1926 //                                                              ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣿⣿⣿⡷⠂⣠⣾⣿⣿⣿⣿⠻⢿⣿⣿⣿⣿⣿⣿⡿⠋⢁⣠
1927 //                                                              ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢋⣡⣴⣾⣿⣿⣿⣿⣿⣿⣷⣦⡈⢿⣶⣶⣶⣿⣦⡀⠊⢻
1928 //                                                              ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡈
1929 //                                                              ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠘
1930 //                                                              ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⣠⣴⣶⣿⣿⣶⣤⣤⣤⣤⣈⣉⣉⣉⣉⣛⡛⠛⠛⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⢛⡀⠹
1931 //                                                              ⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢉⣴⣿⣿⣿⣇⣀⣤⣤⣤⣬⣭⣍⣉⡛⠛⠻⠿⣿⣿⣿⣷⣦⣤⣤⣤⣤⣭⣉⣉⣉⠉⣩⣤⣤⣾⡟⠇⢠
1932 //                                                              ⣿⣿⣿⣿⣿⣿⡏⠹⣿⡇⠘⠛⠛⠛⠛⠛⠛⠛⠛⠛⠿⣿⣿⣿⣿⣿⣶⣶⣤⣤⣬⣭⣍⣙⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠁
1933 //                                                              ⢿⣿⣿⣿⣿⣿⣿⣦⡈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣤⣍⣉⠉⠛⠻⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿
1934 //                                                              ⠀⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣤⣤⠌⠉
1935 //                                                              ⣤⡈⠀⠈⣛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋
1936 //                                                                ⣷⣦⣄⡈⠓⠨⠭⠽⢿⣟⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠿⠛⢋⣁
1937 //                                                                   ⣿⣿⣶⣶⣤⣤⣀⣉⣉⣉⣉⠛⠛⠒⠒⠲⠶⠶⠿⠿⠿⠿⠃⠐⢂⣈⣀⣤⣦⣀
1938 
1939 
1940 contract PepeLand is ERC721A, Ownable, ReentrancyGuard, Pausable{
1941 
1942     // uint256 mint variables
1943     uint256 public maxSupply = 5555;
1944     uint256 public mintPrice = 0.0169 ether; // @dev 10 finney = 0.01 ether
1945     uint256 public wlMaxMint = 10;
1946     uint256 public wlMintPrice = 0.0142 ether;
1947     uint256 public freeMax = 1;
1948 
1949     //base uri, base extension
1950     string public baseExtension = ".json";
1951     string public baseURI;
1952 
1953     // booleans for if mint is enabled
1954     bool public publicMintEnabled = false;
1955     bool public wlMintEnabled = false;
1956 
1957     // mappings to keep track of # of minted tokens per user
1958     mapping(address => uint256) public totalWlMint;
1959     mapping(address => uint256) public totalFreeMints;
1960 
1961     // merkle root
1962     bytes32 public root;
1963 
1964     constructor (
1965         string memory _initBaseURI,
1966         bytes32 _root
1967         ) ERC721A("PEPELAND", "PL") {
1968             setBaseURI(_initBaseURI);
1969             setRoot(_root); 
1970     }
1971 
1972     function airdrop(address[] calldata _address, uint256 _amount) external onlyOwner nonReentrant {
1973 
1974         require(totalSupply() + _amount <= maxSupply, "Error: max supply reached");
1975 
1976         for (uint i = 0; i < _address.length; i++) {
1977             _safeMint(_address[i], _amount);
1978         }
1979     }
1980 
1981     // Whitelist mint that requires merkle proof; user receives 1 free 
1982     function whitelistMint(uint256 _quantity, bytes32[] memory proof) external payable whenNotPaused nonReentrant {
1983         
1984         if (totalFreeMints[msg.sender] == 0 && freeMax <= 1000) {
1985             require(freeMax <= 1000, "No more free Peperinos left!");
1986             require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Not a part of whitelist");
1987             require(wlMintEnabled, "Whitelist mint is currently paused");
1988             require(totalSupply() + _quantity <= 5545, "Error: max supply reached");
1989             require((totalWlMint[msg.sender] + _quantity) <= wlMaxMint, "Error: Cannot mint more than 10");
1990             require(msg.value >= ((_quantity * wlMintPrice) - wlMintPrice), "Not enough ether sent");
1991 
1992             totalFreeMints[msg.sender] += 1;
1993             freeMax += 1;
1994             totalWlMint[msg.sender] += _quantity;
1995             _safeMint(msg.sender, _quantity);
1996 
1997         } else {
1998             require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Not a part of whitelist");
1999             require(wlMintEnabled, "Whitelist mint is currently paused");
2000             require(totalSupply() + _quantity <= 5545, "Error: max supply reached");
2001             require((totalWlMint[msg.sender] + _quantity) <= wlMaxMint, "Error: Cannot mint more than 10");
2002             require(msg.value >= (_quantity * wlMintPrice), "Not enough ether sent");
2003 
2004             totalWlMint[msg.sender] += _quantity;
2005             _safeMint(msg.sender, _quantity);
2006 
2007         }
2008     }
2009 
2010     // verify merkle proof with a buf2hex(keccak256(address)) or keccak256(abi.encodePacked(address))
2011     function isValid(bytes32[] memory proof, bytes32 leaf) public view returns(bool) {
2012         return MerkleProof.verify(proof, root, leaf);
2013     }
2014 
2015     // Public mint with 20 per tx limit
2016 
2017     function publicMint(uint256 _quantity) external payable whenNotPaused nonReentrant {
2018         require(_quantity <= 20, "Cannot mint more than 20 per tx");
2019         require(publicMintEnabled, "Public mint is currently paused");
2020         require(msg.value >= (_quantity * mintPrice), "Not enough ether sent");
2021         require(totalSupply() + _quantity <= 5545, "Error: max supply reached");
2022 
2023         _safeMint(msg.sender, _quantity);
2024     }
2025 
2026     
2027 
2028     // returns the baseuri of collection, private
2029     function _baseURI() internal view virtual override returns (string memory) {
2030         return baseURI;
2031     }
2032 
2033     // override _statTokenId() from erc721a to start tokenId at 1
2034     function _startTokenId() internal view virtual override returns (uint256) {
2035         return 1;
2036     }
2037 
2038     // return tokenUri given the tokenId
2039 
2040     function tokenURI(uint256 tokenId)
2041     public
2042     view
2043     virtual
2044     override
2045     returns (string memory)
2046     {
2047     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
2048     
2049         string memory currentBaseURI = _baseURI();
2050         return bytes(currentBaseURI).length > 0
2051         ? string(abi.encodePacked(currentBaseURI, _toString(tokenId), baseExtension))
2052         : "";
2053         
2054     }
2055 
2056     // owner updates and functions
2057 
2058     function togglePublicMint() external onlyOwner nonReentrant{
2059         publicMintEnabled = !publicMintEnabled;
2060     }
2061 
2062     function toggleWlMint() external onlyOwner nonReentrant{
2063         wlMintEnabled = !wlMintEnabled;
2064     }
2065 
2066     function enableBothMints() external onlyOwner nonReentrant{
2067         wlMintEnabled = true;
2068         publicMintEnabled = true;
2069     }
2070 
2071     function setPrice(uint256 _mintPrice) external onlyOwner nonReentrant{
2072     mintPrice = _mintPrice;
2073     }
2074 
2075     function setWlPrice(uint256 _wlMintPrice) external onlyOwner nonReentrant{
2076     wlMintPrice = _wlMintPrice;
2077     }
2078 
2079     function setmaxWl(uint256 _wlMaxMint) external onlyOwner nonReentrant{
2080     wlMaxMint = _wlMaxMint;
2081     }
2082   
2083     function pause() public onlyOwner nonReentrant{ 
2084         _pause();
2085     }
2086 
2087     function unpause() public onlyOwner nonReentrant{
2088         _unpause();
2089     }
2090 
2091     function setBaseURI(string memory _newURI) public onlyOwner nonReentrant{
2092         baseURI = _newURI;
2093     }
2094 
2095     function setRoot(bytes32 _root) public onlyOwner nonReentrant {
2096         root = _root;
2097     }
2098 
2099     function setMaxSupply(uint256 _maxSupply) external onlyOwner nonReentrant {
2100         maxSupply = _maxSupply;
2101     }
2102 
2103     // withdraw to owner(), i.e only if msg.sender is owner
2104     function withdraw() external onlyOwner nonReentrant {
2105 
2106         payable(0x0837d97d5F619c11420F3035D22F55fF96b8171E).transfer(address(this).balance * 20 / 100);
2107 
2108         payable(owner()).transfer(address(this).balance);
2109     }
2110 
2111 
2112 }