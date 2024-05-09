1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Tree proofs.
11  *
12  * The tree and the proofs can be generated using our
13  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
14  * You will find a quickstart guide in the readme.
15  *
16  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
17  * hashing, or use a hash function other than keccak256 for hashing leaves.
18  * This is because the concatenation of a sorted pair of internal nodes in
19  * the merkle tree could be reinterpreted as a leaf value.
20  * OpenZeppelin's JavaScript library generates merkle trees that are safe
21  * against this attack out of the box.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Calldata version of {verify}
40      *
41      * _Available since v4.7._
42      */
43     function verifyCalldata(
44         bytes32[] calldata proof,
45         bytes32 root,
46         bytes32 leaf
47     ) internal pure returns (bool) {
48         return processProofCalldata(proof, leaf) == root;
49     }
50 
51     /**
52      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
53      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
54      * hash matches the root of the tree. When processing the proof, the pairs
55      * of leafs & pre-images are assumed to be sorted.
56      *
57      * _Available since v4.4._
58      */
59     function processProof(bytes32[] memory proof, bytes32 leaf)
60         internal
61         pure
62         returns (bytes32)
63     {
64         bytes32 computedHash = leaf;
65         for (uint256 i = 0; i < proof.length; i++) {
66             computedHash = _hashPair(computedHash, proof[i]);
67         }
68         return computedHash;
69     }
70 
71     /**
72      * @dev Calldata version of {processProof}
73      *
74      * _Available since v4.7._
75      */
76     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
77         internal
78         pure
79         returns (bytes32)
80     {
81         bytes32 computedHash = leaf;
82         for (uint256 i = 0; i < proof.length; i++) {
83             computedHash = _hashPair(computedHash, proof[i]);
84         }
85         return computedHash;
86     }
87 
88     /**
89      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
90      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
91      *
92      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
93      *
94      * _Available since v4.7._
95      */
96     function multiProofVerify(
97         bytes32[] memory proof,
98         bool[] memory proofFlags,
99         bytes32 root,
100         bytes32[] memory leaves
101     ) internal pure returns (bool) {
102         return processMultiProof(proof, proofFlags, leaves) == root;
103     }
104 
105     /**
106      * @dev Calldata version of {multiProofVerify}
107      *
108      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
109      *
110      * _Available since v4.7._
111      */
112     function multiProofVerifyCalldata(
113         bytes32[] calldata proof,
114         bool[] calldata proofFlags,
115         bytes32 root,
116         bytes32[] memory leaves
117     ) internal pure returns (bool) {
118         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
119     }
120 
121     /**
122      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
123      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
124      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
125      * respectively.
126      *
127      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
128      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
129      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
130      *
131      * _Available since v4.7._
132      */
133     function processMultiProof(
134         bytes32[] memory proof,
135         bool[] memory proofFlags,
136         bytes32[] memory leaves
137     ) internal pure returns (bytes32 merkleRoot) {
138         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
139         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
140         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
141         // the merkle tree.
142         uint256 leavesLen = leaves.length;
143         uint256 totalHashes = proofFlags.length;
144 
145         // Check proof validity.
146         require(
147             leavesLen + proof.length - 1 == totalHashes,
148             "MerkleProof: invalid multiproof"
149         );
150 
151         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
152         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
153         bytes32[] memory hashes = new bytes32[](totalHashes);
154         uint256 leafPos = 0;
155         uint256 hashPos = 0;
156         uint256 proofPos = 0;
157         // At each step, we compute the next hash using two values:
158         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
159         //   get the next hash.
160         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
161         //   `proof` array.
162         for (uint256 i = 0; i < totalHashes; i++) {
163             bytes32 a = leafPos < leavesLen
164                 ? leaves[leafPos++]
165                 : hashes[hashPos++];
166             bytes32 b = proofFlags[i]
167                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
168                 : proof[proofPos++];
169             hashes[i] = _hashPair(a, b);
170         }
171 
172         if (totalHashes > 0) {
173             return hashes[totalHashes - 1];
174         } else if (leavesLen > 0) {
175             return leaves[0];
176         } else {
177             return proof[0];
178         }
179     }
180 
181     /**
182      * @dev Calldata version of {processMultiProof}.
183      *
184      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
185      *
186      * _Available since v4.7._
187      */
188     function processMultiProofCalldata(
189         bytes32[] calldata proof,
190         bool[] calldata proofFlags,
191         bytes32[] memory leaves
192     ) internal pure returns (bytes32 merkleRoot) {
193         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
194         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
195         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
196         // the merkle tree.
197         uint256 leavesLen = leaves.length;
198         uint256 totalHashes = proofFlags.length;
199 
200         // Check proof validity.
201         require(
202             leavesLen + proof.length - 1 == totalHashes,
203             "MerkleProof: invalid multiproof"
204         );
205 
206         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
207         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
208         bytes32[] memory hashes = new bytes32[](totalHashes);
209         uint256 leafPos = 0;
210         uint256 hashPos = 0;
211         uint256 proofPos = 0;
212         // At each step, we compute the next hash using two values:
213         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
214         //   get the next hash.
215         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
216         //   `proof` array.
217         for (uint256 i = 0; i < totalHashes; i++) {
218             bytes32 a = leafPos < leavesLen
219                 ? leaves[leafPos++]
220                 : hashes[hashPos++];
221             bytes32 b = proofFlags[i]
222                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
223                 : proof[proofPos++];
224             hashes[i] = _hashPair(a, b);
225         }
226 
227         if (totalHashes > 0) {
228             return hashes[totalHashes - 1];
229         } else if (leavesLen > 0) {
230             return leaves[0];
231         } else {
232             return proof[0];
233         }
234     }
235 
236     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
237         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
238     }
239 
240     function _efficientHash(bytes32 a, bytes32 b)
241         private
242         pure
243         returns (bytes32 value)
244     {
245         /// @solidity memory-safe-assembly
246         assembly {
247             mstore(0x00, a)
248             mstore(0x20, b)
249             value := keccak256(0x00, 0x40)
250         }
251     }
252 }
253 
254 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
255 
256 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @dev Contract module that helps prevent reentrant calls to a function.
262  *
263  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
264  * available, which can be applied to functions to make sure there are no nested
265  * (reentrant) calls to them.
266  *
267  * Note that because there is a single `nonReentrant` guard, functions marked as
268  * `nonReentrant` may not call one another. This can be worked around by making
269  * those functions `private`, and then adding `external` `nonReentrant` entry
270  * points to them.
271  *
272  * TIP: If you would like to learn more about reentrancy and alternative ways
273  * to protect against it, check out our blog post
274  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
275  */
276 abstract contract ReentrancyGuard {
277     // Booleans are more expensive than uint256 or any type that takes up a full
278     // word because each write operation emits an extra SLOAD to first read the
279     // slot's contents, replace the bits taken up by the boolean, and then write
280     // back. This is the compiler's defense against contract upgrades and
281     // pointer aliasing, and it cannot be disabled.
282 
283     // The values being non-zero value makes deployment a bit more expensive,
284     // but in exchange the refund on every call to nonReentrant will be lower in
285     // amount. Since refunds are capped to a percentage of the total
286     // transaction's gas, it is best to keep them low in cases like this one, to
287     // increase the likelihood of the full refund coming into effect.
288     uint256 private constant _NOT_ENTERED = 1;
289     uint256 private constant _ENTERED = 2;
290 
291     uint256 private _status;
292 
293     constructor() {
294         _status = _NOT_ENTERED;
295     }
296 
297     /**
298      * @dev Prevents a contract from calling itself, directly or indirectly.
299      * Calling a `nonReentrant` function from another `nonReentrant`
300      * function is not supported. It is possible to prevent this from happening
301      * by making the `nonReentrant` function external, and making it call a
302      * `private` function that does the actual work.
303      */
304     modifier nonReentrant() {
305         _nonReentrantBefore();
306         _;
307         _nonReentrantAfter();
308     }
309 
310     function _nonReentrantBefore() private {
311         // On the first call to nonReentrant, _status will be _NOT_ENTERED
312         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
313 
314         // Any calls to nonReentrant after this point will fail
315         _status = _ENTERED;
316     }
317 
318     function _nonReentrantAfter() private {
319         // By storing the original value once again, a refund is triggered (see
320         // https://eips.ethereum.org/EIPS/eip-2200)
321         _status = _NOT_ENTERED;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/utils/Context.sol
326 
327 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Provides information about the current execution context, including the
333  * sender of the transaction and its data. While these are generally available
334  * via msg.sender and msg.data, they should not be accessed in such a direct
335  * manner, since when dealing with meta-transactions the account sending and
336  * paying for execution may not be the actual sender (as far as an application
337  * is concerned).
338  *
339  * This contract is only required for intermediate, library-like contracts.
340  */
341 abstract contract Context {
342     function _msgSender() internal view virtual returns (address) {
343         return msg.sender;
344     }
345 
346     function _msgData() internal view virtual returns (bytes calldata) {
347         return msg.data;
348     }
349 }
350 
351 // File: @openzeppelin/contracts/access/Ownable.sol
352 
353 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 /**
358  * @dev Contract module which provides a basic access control mechanism, where
359  * there is an account (an owner) that can be granted exclusive access to
360  * specific functions.
361  *
362  * By default, the owner account will be the one that deploys the contract. This
363  * can later be changed with {transferOwnership}.
364  *
365  * This module is used through inheritance. It will make available the modifier
366  * `onlyOwner`, which can be applied to your functions to restrict their use to
367  * the owner.
368  */
369 abstract contract Ownable is Context {
370     address private _owner;
371 
372     event OwnershipTransferred(
373         address indexed previousOwner,
374         address indexed newOwner
375     );
376 
377     /**
378      * @dev Initializes the contract setting the deployer as the initial owner.
379      */
380     constructor() {
381         _transferOwnership(_msgSender());
382     }
383 
384     /**
385      * @dev Throws if called by any account other than the owner.
386      */
387     modifier onlyOwner() {
388         _checkOwner();
389         _;
390     }
391 
392     /**
393      * @dev Returns the address of the current owner.
394      */
395     function owner() public view virtual returns (address) {
396         return _owner;
397     }
398 
399     /**
400      * @dev Throws if the sender is not the owner.
401      */
402     function _checkOwner() internal view virtual {
403         require(owner() == _msgSender(), "Ownable: caller is not the owner");
404     }
405 
406     /**
407      * @dev Leaves the contract without owner. It will not be possible to call
408      * `onlyOwner` functions anymore. Can only be called by the current owner.
409      *
410      * NOTE: Renouncing ownership will leave the contract without an owner,
411      * thereby removing any functionality that is only available to the owner.
412      */
413     function renounceOwnership() public virtual onlyOwner {
414         _transferOwnership(address(0));
415     }
416 
417     /**
418      * @dev Transfers ownership of the contract to a new account (`newOwner`).
419      * Can only be called by the current owner.
420      */
421     function transferOwnership(address newOwner) public virtual onlyOwner {
422         require(
423             newOwner != address(0),
424             "Ownable: new owner is the zero address"
425         );
426         _transferOwnership(newOwner);
427     }
428 
429     /**
430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
431      * Internal function without access restriction.
432      */
433     function _transferOwnership(address newOwner) internal virtual {
434         address oldOwner = _owner;
435         _owner = newOwner;
436         emit OwnershipTransferred(oldOwner, newOwner);
437     }
438 }
439 
440 // File: contracts/IERC721A.sol
441 
442 // ERC721A Contracts v4.2.3
443 // Creator: Chiru Labs
444 
445 pragma solidity ^0.8.4;
446 
447 /**
448  * @dev Interface of ERC721A.
449  */
450 interface IERC721A {
451     /**
452      * The caller must own the token or be an approved operator.
453      */
454     error ApprovalCallerNotOwnerNorApproved();
455 
456     /**
457      * The token does not exist.
458      */
459     error ApprovalQueryForNonexistentToken();
460 
461     /**
462      * Cannot query the balance for the zero address.
463      */
464     error BalanceQueryForZeroAddress();
465 
466     /**
467      * Cannot mint to the zero address.
468      */
469     error MintToZeroAddress();
470 
471     /**
472      * The quantity of tokens minted must be more than zero.
473      */
474     error MintZeroQuantity();
475 
476     /**
477      * The token does not exist.
478      */
479     error OwnerQueryForNonexistentToken();
480 
481     /**
482      * The caller must own the token or be an approved operator.
483      */
484     error TransferCallerNotOwnerNorApproved();
485 
486     /**
487      * The token must be owned by `from`.
488      */
489     error TransferFromIncorrectOwner();
490 
491     /**
492      * Cannot safely transfer to a contract that does not implement the
493      * ERC721Receiver interface.
494      */
495     error TransferToNonERC721ReceiverImplementer();
496 
497     /**
498      * Cannot transfer to the zero address.
499      */
500     error TransferToZeroAddress();
501 
502     /**
503      * The token does not exist.
504      */
505     error URIQueryForNonexistentToken();
506 
507     /**
508      * The `quantity` minted with ERC2309 exceeds the safety limit.
509      */
510     error MintERC2309QuantityExceedsLimit();
511 
512     /**
513      * The `extraData` cannot be set on an unintialized ownership slot.
514      */
515     error OwnershipNotInitializedForExtraData();
516 
517     // =============================================================
518     //                            STRUCTS
519     // =============================================================
520 
521     struct TokenOwnership {
522         // The address of the owner.
523         address addr;
524         // Stores the start time of ownership with minimal overhead for tokenomics.
525         uint64 startTimestamp;
526         // Whether the token has been burned.
527         bool burned;
528         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
529         uint24 extraData;
530     }
531 
532     // =============================================================
533     //                         TOKEN COUNTERS
534     // =============================================================
535 
536     /**
537      * @dev Returns the total number of tokens in existence.
538      * Burned tokens will reduce the count.
539      * To get the total number of tokens minted, please see {_totalMinted}.
540      */
541     function totalSupply() external view returns (uint256);
542 
543     // =============================================================
544     //                            IERC165
545     // =============================================================
546 
547     /**
548      * @dev Returns true if this contract implements the interface defined by
549      * `interfaceId`. See the corresponding
550      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
551      * to learn more about how these ids are created.
552      *
553      * This function call must use less than 30000 gas.
554      */
555     function supportsInterface(bytes4 interfaceId) external view returns (bool);
556 
557     // =============================================================
558     //                            IERC721
559     // =============================================================
560 
561     /**
562      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
563      */
564     event Transfer(
565         address indexed from,
566         address indexed to,
567         uint256 indexed tokenId
568     );
569 
570     /**
571      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
572      */
573     event Approval(
574         address indexed owner,
575         address indexed approved,
576         uint256 indexed tokenId
577     );
578 
579     /**
580      * @dev Emitted when `owner` enables or disables
581      * (`approved`) `operator` to manage all of its assets.
582      */
583     event ApprovalForAll(
584         address indexed owner,
585         address indexed operator,
586         bool approved
587     );
588 
589     /**
590      * @dev Returns the number of tokens in `owner`'s account.
591      */
592     function balanceOf(address owner) external view returns (uint256 balance);
593 
594     /**
595      * @dev Returns the owner of the `tokenId` token.
596      *
597      * Requirements:
598      *
599      * - `tokenId` must exist.
600      */
601     function ownerOf(uint256 tokenId) external view returns (address owner);
602 
603     /**
604      * @dev Safely transfers `tokenId` token from `from` to `to`,
605      * checking first that contract recipients are aware of the ERC721 protocol
606      * to prevent tokens from being forever locked.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must exist and be owned by `from`.
613      * - If the caller is not `from`, it must be have been allowed to move
614      * this token by either {approve} or {setApprovalForAll}.
615      * - If `to` refers to a smart contract, it must implement
616      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
617      *
618      * Emits a {Transfer} event.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 tokenId,
624         bytes calldata data
625     ) external payable;
626 
627     /**
628      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) external payable;
635 
636     /**
637      * @dev Transfers `tokenId` from `from` to `to`.
638      *
639      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
640      * whenever possible.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must be owned by `from`.
647      * - If the caller is not `from`, it must be approved to move this token
648      * by either {approve} or {setApprovalForAll}.
649      *
650      * Emits a {Transfer} event.
651      */
652     function transferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) external payable;
657 
658     /**
659      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
660      * The approval is cleared when the token is transferred.
661      *
662      * Only a single account can be approved at a time, so approving the
663      * zero address clears previous approvals.
664      *
665      * Requirements:
666      *
667      * - The caller must own the token or be an approved operator.
668      * - `tokenId` must exist.
669      *
670      * Emits an {Approval} event.
671      */
672     function approve(address to, uint256 tokenId) external payable;
673 
674     /**
675      * @dev Approve or remove `operator` as an operator for the caller.
676      * Operators can call {transferFrom} or {safeTransferFrom}
677      * for any token owned by the caller.
678      *
679      * Requirements:
680      *
681      * - The `operator` cannot be the caller.
682      *
683      * Emits an {ApprovalForAll} event.
684      */
685     function setApprovalForAll(address operator, bool _approved) external;
686 
687     /**
688      * @dev Returns the account approved for `tokenId` token.
689      *
690      * Requirements:
691      *
692      * - `tokenId` must exist.
693      */
694     function getApproved(uint256 tokenId)
695         external
696         view
697         returns (address operator);
698 
699     /**
700      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
701      *
702      * See {setApprovalForAll}.
703      */
704     function isApprovedForAll(address owner, address operator)
705         external
706         view
707         returns (bool);
708 
709     // =============================================================
710     //                        IERC721Metadata
711     // =============================================================
712 
713     /**
714      * @dev Returns the token collection name.
715      */
716     function name() external view returns (string memory);
717 
718     /**
719      * @dev Returns the token collection symbol.
720      */
721     function symbol() external view returns (string memory);
722 
723     /**
724      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
725      */
726     function tokenURI(uint256 tokenId) external view returns (string memory);
727 
728     // =============================================================
729     //                           IERC2309
730     // =============================================================
731 
732     /**
733      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
734      * (inclusive) is transferred from `from` to `to`, as defined in the
735      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
736      *
737      * See {_mintERC2309} for more details.
738      */
739     event ConsecutiveTransfer(
740         uint256 indexed fromTokenId,
741         uint256 toTokenId,
742         address indexed from,
743         address indexed to
744     );
745 }
746 
747 // File: contracts/ERC721A.sol
748 
749 // ERC721A Contracts v4.2.3
750 // Creator: Chiru Labs
751 
752 pragma solidity ^0.8.4;
753 
754 /**
755  * @dev Interface of ERC721 token receiver.
756  */
757 interface ERC721A__IERC721Receiver {
758     function onERC721Received(
759         address operator,
760         address from,
761         uint256 tokenId,
762         bytes calldata data
763     ) external returns (bytes4);
764 }
765 
766 /**
767  * @title ERC721A
768  *
769  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
770  * Non-Fungible Token Standard, including the Metadata extension.
771  * Optimized for lower gas during batch mints.
772  *
773  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
774  * starting from `_startTokenId()`.
775  *
776  * Assumptions:
777  *
778  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
779  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
780  */
781 contract ERC721A is IERC721A {
782     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
783     struct TokenApprovalRef {
784         address value;
785     }
786 
787     // =============================================================
788     //                           CONSTANTS
789     // =============================================================
790 
791     // Mask of an entry in packed address data.
792     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
793 
794     // The bit position of `numberMinted` in packed address data.
795     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
796 
797     // The bit position of `numberBurned` in packed address data.
798     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
799 
800     // The bit position of `aux` in packed address data.
801     uint256 private constant _BITPOS_AUX = 192;
802 
803     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
804     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
805 
806     // The bit position of `startTimestamp` in packed ownership.
807     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
808 
809     // The bit mask of the `burned` bit in packed ownership.
810     uint256 private constant _BITMASK_BURNED = 1 << 224;
811 
812     // The bit position of the `nextInitialized` bit in packed ownership.
813     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
814 
815     // The bit mask of the `nextInitialized` bit in packed ownership.
816     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
817 
818     // The bit position of `extraData` in packed ownership.
819     uint256 private constant _BITPOS_EXTRA_DATA = 232;
820 
821     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
822     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
823 
824     // The mask of the lower 160 bits for addresses.
825     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
826 
827     // The maximum `quantity` that can be minted with {_mintERC2309}.
828     // This limit is to prevent overflows on the address data entries.
829     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
830     // is required to cause an overflow, which is unrealistic.
831     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
832 
833     // The `Transfer` event signature is given by:
834     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
835     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
836         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
837 
838     // =============================================================
839     //                            STORAGE
840     // =============================================================
841 
842     // The next token ID to be minted.
843     uint256 private _currentIndex;
844 
845     // The number of tokens burned.
846     uint256 private _burnCounter;
847 
848     // Token name
849     string private _name;
850 
851     // Token symbol
852     string private _symbol;
853 
854     // Mapping from token ID to ownership details
855     // An empty struct value does not necessarily mean the token is unowned.
856     // See {_packedOwnershipOf} implementation for details.
857     //
858     // Bits Layout:
859     // - [0..159]   `addr`
860     // - [160..223] `startTimestamp`
861     // - [224]      `burned`
862     // - [225]      `nextInitialized`
863     // - [232..255] `extraData`
864     mapping(uint256 => uint256) private _packedOwnerships;
865 
866     // Mapping owner address to address data.
867     //
868     // Bits Layout:
869     // - [0..63]    `balance`
870     // - [64..127]  `numberMinted`
871     // - [128..191] `numberBurned`
872     // - [192..255] `aux`
873     mapping(address => uint256) private _packedAddressData;
874 
875     // Mapping from token ID to approved address.
876     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
877 
878     // Mapping from owner to operator approvals
879     mapping(address => mapping(address => bool)) private _operatorApprovals;
880 
881     // =============================================================
882     //                          CONSTRUCTOR
883     // =============================================================
884 
885     constructor(string memory name_, string memory symbol_) {
886         _name = name_;
887         _symbol = symbol_;
888         _currentIndex = _startTokenId();
889     }
890 
891     // =============================================================
892     //                   TOKEN COUNTING OPERATIONS
893     // =============================================================
894 
895     /**
896      * @dev Returns the starting token ID.
897      * To change the starting token ID, please override this function.
898      */
899     function _startTokenId() internal view virtual returns (uint256) {
900         return 0;
901     }
902 
903     /**
904      * @dev Returns the next token ID to be minted.
905      */
906     function _nextTokenId() internal view virtual returns (uint256) {
907         return _currentIndex;
908     }
909 
910     /**
911      * @dev Returns the total number of tokens in existence.
912      * Burned tokens will reduce the count.
913      * To get the total number of tokens minted, please see {_totalMinted}.
914      */
915     function totalSupply() public view virtual override returns (uint256) {
916         // Counter underflow is impossible as _burnCounter cannot be incremented
917         // more than `_currentIndex - _startTokenId()` times.
918         unchecked {
919             return _currentIndex - _burnCounter - _startTokenId();
920         }
921     }
922 
923     /**
924      * @dev Returns the total amount of tokens minted in the contract.
925      */
926     function _totalMinted() internal view virtual returns (uint256) {
927         // Counter underflow is impossible as `_currentIndex` does not decrement,
928         // and it is initialized to `_startTokenId()`.
929         unchecked {
930             return _currentIndex - _startTokenId();
931         }
932     }
933 
934     /**
935      * @dev Returns the total number of tokens burned.
936      */
937     function _totalBurned() internal view virtual returns (uint256) {
938         return _burnCounter;
939     }
940 
941     // =============================================================
942     //                    ADDRESS DATA OPERATIONS
943     // =============================================================
944 
945     /**
946      * @dev Returns the number of tokens in `owner`'s account.
947      */
948     function balanceOf(address owner)
949         public
950         view
951         virtual
952         override
953         returns (uint256)
954     {
955         if (owner == address(0)) revert BalanceQueryForZeroAddress();
956         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
957     }
958 
959     /**
960      * Returns the number of tokens minted by `owner`.
961      */
962     function _numberMinted(address owner) internal view returns (uint256) {
963         return
964             (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) &
965             _BITMASK_ADDRESS_DATA_ENTRY;
966     }
967 
968     /**
969      * Returns the number of tokens burned by or on behalf of `owner`.
970      */
971     function _numberBurned(address owner) internal view returns (uint256) {
972         return
973             (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) &
974             _BITMASK_ADDRESS_DATA_ENTRY;
975     }
976 
977     /**
978      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
979      */
980     function _getAux(address owner) internal view returns (uint64) {
981         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
982     }
983 
984     /**
985      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
986      * If there are multiple variables, please pack them into a uint64.
987      */
988     function _setAux(address owner, uint64 aux) internal virtual {
989         uint256 packed = _packedAddressData[owner];
990         uint256 auxCasted;
991         // Cast `aux` with assembly to avoid redundant masking.
992         assembly {
993             auxCasted := aux
994         }
995         packed =
996             (packed & _BITMASK_AUX_COMPLEMENT) |
997             (auxCasted << _BITPOS_AUX);
998         _packedAddressData[owner] = packed;
999     }
1000 
1001     // =============================================================
1002     //                            IERC165
1003     // =============================================================
1004 
1005     /**
1006      * @dev Returns true if this contract implements the interface defined by
1007      * `interfaceId`. See the corresponding
1008      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1009      * to learn more about how these ids are created.
1010      *
1011      * This function call must use less than 30000 gas.
1012      */
1013     function supportsInterface(bytes4 interfaceId)
1014         public
1015         view
1016         virtual
1017         override
1018         returns (bool)
1019     {
1020         // The interface IDs are constants representing the first 4 bytes
1021         // of the XOR of all function selectors in the interface.
1022         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1023         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1024         return
1025             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1026             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1027             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1028     }
1029 
1030     // =============================================================
1031     //                        IERC721Metadata
1032     // =============================================================
1033 
1034     /**
1035      * @dev Returns the token collection name.
1036      */
1037     function name() public view virtual override returns (string memory) {
1038         return _name;
1039     }
1040 
1041     /**
1042      * @dev Returns the token collection symbol.
1043      */
1044     function symbol() public view virtual override returns (string memory) {
1045         return _symbol;
1046     }
1047 
1048     /**
1049      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1050      */
1051     function tokenURI(uint256 tokenId)
1052         public
1053         view
1054         virtual
1055         override
1056         returns (string memory)
1057     {
1058         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1059 
1060         string memory baseURI = _baseURI();
1061         return
1062             bytes(baseURI).length != 0
1063                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
1064                 : "";
1065     }
1066 
1067     /**
1068      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1069      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1070      * by default, it can be overridden in child contracts.
1071      */
1072     function _baseURI() internal view virtual returns (string memory) {
1073         return "";
1074     }
1075 
1076     // =============================================================
1077     //                     OWNERSHIPS OPERATIONS
1078     // =============================================================
1079 
1080     /**
1081      * @dev Returns the owner of the `tokenId` token.
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must exist.
1086      */
1087     function ownerOf(uint256 tokenId)
1088         public
1089         view
1090         virtual
1091         override
1092         returns (address)
1093     {
1094         return address(uint160(_packedOwnershipOf(tokenId)));
1095     }
1096 
1097     /**
1098      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1099      * It gradually moves to O(1) as tokens get transferred around over time.
1100      */
1101     function _ownershipOf(uint256 tokenId)
1102         internal
1103         view
1104         virtual
1105         returns (TokenOwnership memory)
1106     {
1107         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1108     }
1109 
1110     /**
1111      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1112      */
1113     function _ownershipAt(uint256 index)
1114         internal
1115         view
1116         virtual
1117         returns (TokenOwnership memory)
1118     {
1119         return _unpackedOwnership(_packedOwnerships[index]);
1120     }
1121 
1122     /**
1123      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1124      */
1125     function _initializeOwnershipAt(uint256 index) internal virtual {
1126         if (_packedOwnerships[index] == 0) {
1127             _packedOwnerships[index] = _packedOwnershipOf(index);
1128         }
1129     }
1130 
1131     /**
1132      * Returns the packed ownership data of `tokenId`.
1133      */
1134     function _packedOwnershipOf(uint256 tokenId)
1135         private
1136         view
1137         returns (uint256)
1138     {
1139         uint256 curr = tokenId;
1140 
1141         unchecked {
1142             if (_startTokenId() <= curr)
1143                 if (curr < _currentIndex) {
1144                     uint256 packed = _packedOwnerships[curr];
1145                     // If not burned.
1146                     if (packed & _BITMASK_BURNED == 0) {
1147                         // Invariant:
1148                         // There will always be an initialized ownership slot
1149                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1150                         // before an unintialized ownership slot
1151                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1152                         // Hence, `curr` will not underflow.
1153                         //
1154                         // We can directly compare the packed value.
1155                         // If the address is zero, packed will be zero.
1156                         while (packed == 0) {
1157                             packed = _packedOwnerships[--curr];
1158                         }
1159                         return packed;
1160                     }
1161                 }
1162         }
1163         revert OwnerQueryForNonexistentToken();
1164     }
1165 
1166     /**
1167      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1168      */
1169     function _unpackedOwnership(uint256 packed)
1170         private
1171         pure
1172         returns (TokenOwnership memory ownership)
1173     {
1174         ownership.addr = address(uint160(packed));
1175         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1176         ownership.burned = packed & _BITMASK_BURNED != 0;
1177         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1178     }
1179 
1180     /**
1181      * @dev Packs ownership data into a single uint256.
1182      */
1183     function _packOwnershipData(address owner, uint256 flags)
1184         private
1185         view
1186         returns (uint256 result)
1187     {
1188         assembly {
1189             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1190             owner := and(owner, _BITMASK_ADDRESS)
1191             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1192             result := or(
1193                 owner,
1194                 or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags)
1195             )
1196         }
1197     }
1198 
1199     /**
1200      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1201      */
1202     function _nextInitializedFlag(uint256 quantity)
1203         private
1204         pure
1205         returns (uint256 result)
1206     {
1207         // For branchless setting of the `nextInitialized` flag.
1208         assembly {
1209             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1210             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1211         }
1212     }
1213 
1214     // =============================================================
1215     //                      APPROVAL OPERATIONS
1216     // =============================================================
1217 
1218     /**
1219      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1220      * The approval is cleared when the token is transferred.
1221      *
1222      * Only a single account can be approved at a time, so approving the
1223      * zero address clears previous approvals.
1224      *
1225      * Requirements:
1226      *
1227      * - The caller must own the token or be an approved operator.
1228      * - `tokenId` must exist.
1229      *
1230      * Emits an {Approval} event.
1231      */
1232     function approve(address to, uint256 tokenId)
1233         public
1234         payable
1235         virtual
1236         override
1237     {
1238         address owner = ownerOf(tokenId);
1239 
1240         if (_msgSenderERC721A() != owner)
1241             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1242                 revert ApprovalCallerNotOwnerNorApproved();
1243             }
1244 
1245         _tokenApprovals[tokenId].value = to;
1246         emit Approval(owner, to, tokenId);
1247     }
1248 
1249     /**
1250      * @dev Returns the account approved for `tokenId` token.
1251      *
1252      * Requirements:
1253      *
1254      * - `tokenId` must exist.
1255      */
1256     function getApproved(uint256 tokenId)
1257         public
1258         view
1259         virtual
1260         override
1261         returns (address)
1262     {
1263         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1264 
1265         return _tokenApprovals[tokenId].value;
1266     }
1267 
1268     /**
1269      * @dev Approve or remove `operator` as an operator for the caller.
1270      * Operators can call {transferFrom} or {safeTransferFrom}
1271      * for any token owned by the caller.
1272      *
1273      * Requirements:
1274      *
1275      * - The `operator` cannot be the caller.
1276      *
1277      * Emits an {ApprovalForAll} event.
1278      */
1279     function setApprovalForAll(address operator, bool approved)
1280         public
1281         virtual
1282         override
1283     {
1284         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1285         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1286     }
1287 
1288     /**
1289      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1290      *
1291      * See {setApprovalForAll}.
1292      */
1293     function isApprovedForAll(address owner, address operator)
1294         public
1295         view
1296         virtual
1297         override
1298         returns (bool)
1299     {
1300         return _operatorApprovals[owner][operator];
1301     }
1302 
1303     /**
1304      * @dev Returns whether `tokenId` exists.
1305      *
1306      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1307      *
1308      * Tokens start existing when they are minted. See {_mint}.
1309      */
1310     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1311         return
1312             _startTokenId() <= tokenId &&
1313             tokenId < _currentIndex && // If within bounds,
1314             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1315     }
1316 
1317     /**
1318      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1319      */
1320     function _isSenderApprovedOrOwner(
1321         address approvedAddress,
1322         address owner,
1323         address msgSender
1324     ) private pure returns (bool result) {
1325         assembly {
1326             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1327             owner := and(owner, _BITMASK_ADDRESS)
1328             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1329             msgSender := and(msgSender, _BITMASK_ADDRESS)
1330             // `msgSender == owner || msgSender == approvedAddress`.
1331             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1332         }
1333     }
1334 
1335     /**
1336      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1337      */
1338     function _getApprovedSlotAndAddress(uint256 tokenId)
1339         private
1340         view
1341         returns (uint256 approvedAddressSlot, address approvedAddress)
1342     {
1343         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1344         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1345         assembly {
1346             approvedAddressSlot := tokenApproval.slot
1347             approvedAddress := sload(approvedAddressSlot)
1348         }
1349     }
1350 
1351     // =============================================================
1352     //                      TRANSFER OPERATIONS
1353     // =============================================================
1354 
1355     /**
1356      * @dev Transfers `tokenId` from `from` to `to`.
1357      *
1358      * Requirements:
1359      *
1360      * - `from` cannot be the zero address.
1361      * - `to` cannot be the zero address.
1362      * - `tokenId` token must be owned by `from`.
1363      * - If the caller is not `from`, it must be approved to move this token
1364      * by either {approve} or {setApprovalForAll}.
1365      *
1366      * Emits a {Transfer} event.
1367      */
1368     function transferFrom(
1369         address from,
1370         address to,
1371         uint256 tokenId
1372     ) public payable virtual override {
1373         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1374 
1375         if (address(uint160(prevOwnershipPacked)) != from)
1376             revert TransferFromIncorrectOwner();
1377 
1378         (
1379             uint256 approvedAddressSlot,
1380             address approvedAddress
1381         ) = _getApprovedSlotAndAddress(tokenId);
1382 
1383         // The nested ifs save around 20+ gas over a compound boolean condition.
1384         if (
1385             !_isSenderApprovedOrOwner(
1386                 approvedAddress,
1387                 from,
1388                 _msgSenderERC721A()
1389             )
1390         )
1391             if (!isApprovedForAll(from, _msgSenderERC721A()))
1392                 revert TransferCallerNotOwnerNorApproved();
1393 
1394         if (to == address(0)) revert TransferToZeroAddress();
1395 
1396         _beforeTokenTransfers(from, to, tokenId, 1);
1397 
1398         // Clear approvals from the previous owner.
1399         assembly {
1400             if approvedAddress {
1401                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1402                 sstore(approvedAddressSlot, 0)
1403             }
1404         }
1405 
1406         // Underflow of the sender's balance is impossible because we check for
1407         // ownership above and the recipient's balance can't realistically overflow.
1408         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1409         unchecked {
1410             // We can directly increment and decrement the balances.
1411             --_packedAddressData[from]; // Updates: `balance -= 1`.
1412             ++_packedAddressData[to]; // Updates: `balance += 1`.
1413 
1414             // Updates:
1415             // - `address` to the next owner.
1416             // - `startTimestamp` to the timestamp of transfering.
1417             // - `burned` to `false`.
1418             // - `nextInitialized` to `true`.
1419             _packedOwnerships[tokenId] = _packOwnershipData(
1420                 to,
1421                 _BITMASK_NEXT_INITIALIZED |
1422                     _nextExtraData(from, to, prevOwnershipPacked)
1423             );
1424 
1425             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1426             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1427                 uint256 nextTokenId = tokenId + 1;
1428                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1429                 if (_packedOwnerships[nextTokenId] == 0) {
1430                     // If the next slot is within bounds.
1431                     if (nextTokenId != _currentIndex) {
1432                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1433                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1434                     }
1435                 }
1436             }
1437         }
1438 
1439         emit Transfer(from, to, tokenId);
1440         _afterTokenTransfers(from, to, tokenId, 1);
1441     }
1442 
1443     /**
1444      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1445      */
1446     function safeTransferFrom(
1447         address from,
1448         address to,
1449         uint256 tokenId
1450     ) public payable virtual override {
1451         safeTransferFrom(from, to, tokenId, "");
1452     }
1453 
1454     /**
1455      * @dev Safely transfers `tokenId` token from `from` to `to`.
1456      *
1457      * Requirements:
1458      *
1459      * - `from` cannot be the zero address.
1460      * - `to` cannot be the zero address.
1461      * - `tokenId` token must exist and be owned by `from`.
1462      * - If the caller is not `from`, it must be approved to move this token
1463      * by either {approve} or {setApprovalForAll}.
1464      * - If `to` refers to a smart contract, it must implement
1465      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1466      *
1467      * Emits a {Transfer} event.
1468      */
1469     function safeTransferFrom(
1470         address from,
1471         address to,
1472         uint256 tokenId,
1473         bytes memory _data
1474     ) public payable virtual override {
1475         transferFrom(from, to, tokenId);
1476         if (to.code.length != 0)
1477             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1478                 revert TransferToNonERC721ReceiverImplementer();
1479             }
1480     }
1481 
1482     /**
1483      * @dev Hook that is called before a set of serially-ordered token IDs
1484      * are about to be transferred. This includes minting.
1485      * And also called before burning one token.
1486      *
1487      * `startTokenId` - the first token ID to be transferred.
1488      * `quantity` - the amount to be transferred.
1489      *
1490      * Calling conditions:
1491      *
1492      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1493      * transferred to `to`.
1494      * - When `from` is zero, `tokenId` will be minted for `to`.
1495      * - When `to` is zero, `tokenId` will be burned by `from`.
1496      * - `from` and `to` are never both zero.
1497      */
1498     function _beforeTokenTransfers(
1499         address from,
1500         address to,
1501         uint256 startTokenId,
1502         uint256 quantity
1503     ) internal virtual {}
1504 
1505     /**
1506      * @dev Hook that is called after a set of serially-ordered token IDs
1507      * have been transferred. This includes minting.
1508      * And also called after one token has been burned.
1509      *
1510      * `startTokenId` - the first token ID to be transferred.
1511      * `quantity` - the amount to be transferred.
1512      *
1513      * Calling conditions:
1514      *
1515      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1516      * transferred to `to`.
1517      * - When `from` is zero, `tokenId` has been minted for `to`.
1518      * - When `to` is zero, `tokenId` has been burned by `from`.
1519      * - `from` and `to` are never both zero.
1520      */
1521     function _afterTokenTransfers(
1522         address from,
1523         address to,
1524         uint256 startTokenId,
1525         uint256 quantity
1526     ) internal virtual {}
1527 
1528     /**
1529      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1530      *
1531      * `from` - Previous owner of the given token ID.
1532      * `to` - Target address that will receive the token.
1533      * `tokenId` - Token ID to be transferred.
1534      * `_data` - Optional data to send along with the call.
1535      *
1536      * Returns whether the call correctly returned the expected magic value.
1537      */
1538     function _checkContractOnERC721Received(
1539         address from,
1540         address to,
1541         uint256 tokenId,
1542         bytes memory _data
1543     ) private returns (bool) {
1544         try
1545             ERC721A__IERC721Receiver(to).onERC721Received(
1546                 _msgSenderERC721A(),
1547                 from,
1548                 tokenId,
1549                 _data
1550             )
1551         returns (bytes4 retval) {
1552             return
1553                 retval ==
1554                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1555         } catch (bytes memory reason) {
1556             if (reason.length == 0) {
1557                 revert TransferToNonERC721ReceiverImplementer();
1558             } else {
1559                 assembly {
1560                     revert(add(32, reason), mload(reason))
1561                 }
1562             }
1563         }
1564     }
1565 
1566     // =============================================================
1567     //                        MINT OPERATIONS
1568     // =============================================================
1569 
1570     /**
1571      * @dev Mints `quantity` tokens and transfers them to `to`.
1572      *
1573      * Requirements:
1574      *
1575      * - `to` cannot be the zero address.
1576      * - `quantity` must be greater than 0.
1577      *
1578      * Emits a {Transfer} event for each mint.
1579      */
1580     function _mint(address to, uint256 quantity) internal virtual {
1581         uint256 startTokenId = _currentIndex;
1582         if (quantity == 0) revert MintZeroQuantity();
1583 
1584         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1585 
1586         // Overflows are incredibly unrealistic.
1587         // `balance` and `numberMinted` have a maximum limit of 2**64.
1588         // `tokenId` has a maximum limit of 2**256.
1589         unchecked {
1590             // Updates:
1591             // - `balance += quantity`.
1592             // - `numberMinted += quantity`.
1593             //
1594             // We can directly add to the `balance` and `numberMinted`.
1595             _packedAddressData[to] +=
1596                 quantity *
1597                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
1598 
1599             // Updates:
1600             // - `address` to the owner.
1601             // - `startTimestamp` to the timestamp of minting.
1602             // - `burned` to `false`.
1603             // - `nextInitialized` to `quantity == 1`.
1604             _packedOwnerships[startTokenId] = _packOwnershipData(
1605                 to,
1606                 _nextInitializedFlag(quantity) |
1607                     _nextExtraData(address(0), to, 0)
1608             );
1609 
1610             uint256 toMasked;
1611             uint256 end = startTokenId + quantity;
1612 
1613             // Use assembly to loop and emit the `Transfer` event for gas savings.
1614             // The duplicated `log4` removes an extra check and reduces stack juggling.
1615             // The assembly, together with the surrounding Solidity code, have been
1616             // delicately arranged to nudge the compiler into producing optimized opcodes.
1617             assembly {
1618                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1619                 toMasked := and(to, _BITMASK_ADDRESS)
1620                 // Emit the `Transfer` event.
1621                 log4(
1622                     0, // Start of data (0, since no data).
1623                     0, // End of data (0, since no data).
1624                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1625                     0, // `address(0)`.
1626                     toMasked, // `to`.
1627                     startTokenId // `tokenId`.
1628                 )
1629 
1630                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1631                 // that overflows uint256 will make the loop run out of gas.
1632                 // The compiler will optimize the `iszero` away for performance.
1633                 for {
1634                     let tokenId := add(startTokenId, 1)
1635                 } iszero(eq(tokenId, end)) {
1636                     tokenId := add(tokenId, 1)
1637                 } {
1638                     // Emit the `Transfer` event. Similar to above.
1639                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1640                 }
1641             }
1642             if (toMasked == 0) revert MintToZeroAddress();
1643 
1644             _currentIndex = end;
1645         }
1646         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1647     }
1648 
1649     /**
1650      * @dev Mints `quantity` tokens and transfers them to `to`.
1651      *
1652      * This function is intended for efficient minting only during contract creation.
1653      *
1654      * It emits only one {ConsecutiveTransfer} as defined in
1655      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1656      * instead of a sequence of {Transfer} event(s).
1657      *
1658      * Calling this function outside of contract creation WILL make your contract
1659      * non-compliant with the ERC721 standard.
1660      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1661      * {ConsecutiveTransfer} event is only permissible during contract creation.
1662      *
1663      * Requirements:
1664      *
1665      * - `to` cannot be the zero address.
1666      * - `quantity` must be greater than 0.
1667      *
1668      * Emits a {ConsecutiveTransfer} event.
1669      */
1670     function _mintERC2309(address to, uint256 quantity) internal virtual {
1671         uint256 startTokenId = _currentIndex;
1672         if (to == address(0)) revert MintToZeroAddress();
1673         if (quantity == 0) revert MintZeroQuantity();
1674         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT)
1675             revert MintERC2309QuantityExceedsLimit();
1676 
1677         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1678 
1679         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1680         unchecked {
1681             // Updates:
1682             // - `balance += quantity`.
1683             // - `numberMinted += quantity`.
1684             //
1685             // We can directly add to the `balance` and `numberMinted`.
1686             _packedAddressData[to] +=
1687                 quantity *
1688                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
1689 
1690             // Updates:
1691             // - `address` to the owner.
1692             // - `startTimestamp` to the timestamp of minting.
1693             // - `burned` to `false`.
1694             // - `nextInitialized` to `quantity == 1`.
1695             _packedOwnerships[startTokenId] = _packOwnershipData(
1696                 to,
1697                 _nextInitializedFlag(quantity) |
1698                     _nextExtraData(address(0), to, 0)
1699             );
1700 
1701             emit ConsecutiveTransfer(
1702                 startTokenId,
1703                 startTokenId + quantity - 1,
1704                 address(0),
1705                 to
1706             );
1707 
1708             _currentIndex = startTokenId + quantity;
1709         }
1710         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1711     }
1712 
1713     /**
1714      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1715      *
1716      * Requirements:
1717      *
1718      * - If `to` refers to a smart contract, it must implement
1719      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1720      * - `quantity` must be greater than 0.
1721      *
1722      * See {_mint}.
1723      *
1724      * Emits a {Transfer} event for each mint.
1725      */
1726     function _safeMint(
1727         address to,
1728         uint256 quantity,
1729         bytes memory _data
1730     ) internal virtual {
1731         _mint(to, quantity);
1732 
1733         unchecked {
1734             if (to.code.length != 0) {
1735                 uint256 end = _currentIndex;
1736                 uint256 index = end - quantity;
1737                 do {
1738                     if (
1739                         !_checkContractOnERC721Received(
1740                             address(0),
1741                             to,
1742                             index++,
1743                             _data
1744                         )
1745                     ) {
1746                         revert TransferToNonERC721ReceiverImplementer();
1747                     }
1748                 } while (index < end);
1749                 // Reentrancy protection.
1750                 if (_currentIndex != end) revert();
1751             }
1752         }
1753     }
1754 
1755     /**
1756      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1757      */
1758     function _safeMint(address to, uint256 quantity) internal virtual {
1759         _safeMint(to, quantity, "");
1760     }
1761 
1762     // =============================================================
1763     //                        BURN OPERATIONS
1764     // =============================================================
1765 
1766     /**
1767      * @dev Equivalent to `_burn(tokenId, false)`.
1768      */
1769     function _burn(uint256 tokenId) internal virtual {
1770         _burn(tokenId, false);
1771     }
1772 
1773     /**
1774      * @dev Destroys `tokenId`.
1775      * The approval is cleared when the token is burned.
1776      *
1777      * Requirements:
1778      *
1779      * - `tokenId` must exist.
1780      *
1781      * Emits a {Transfer} event.
1782      */
1783     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1784         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1785 
1786         address from = address(uint160(prevOwnershipPacked));
1787 
1788         (
1789             uint256 approvedAddressSlot,
1790             address approvedAddress
1791         ) = _getApprovedSlotAndAddress(tokenId);
1792 
1793         if (approvalCheck) {
1794             // The nested ifs save around 20+ gas over a compound boolean condition.
1795             if (
1796                 !_isSenderApprovedOrOwner(
1797                     approvedAddress,
1798                     from,
1799                     _msgSenderERC721A()
1800                 )
1801             )
1802                 if (!isApprovedForAll(from, _msgSenderERC721A()))
1803                     revert TransferCallerNotOwnerNorApproved();
1804         }
1805 
1806         _beforeTokenTransfers(from, address(0), tokenId, 1);
1807 
1808         // Clear approvals from the previous owner.
1809         assembly {
1810             if approvedAddress {
1811                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1812                 sstore(approvedAddressSlot, 0)
1813             }
1814         }
1815 
1816         // Underflow of the sender's balance is impossible because we check for
1817         // ownership above and the recipient's balance can't realistically overflow.
1818         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1819         unchecked {
1820             // Updates:
1821             // - `balance -= 1`.
1822             // - `numberBurned += 1`.
1823             //
1824             // We can directly decrement the balance, and increment the number burned.
1825             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1826             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1827 
1828             // Updates:
1829             // - `address` to the last owner.
1830             // - `startTimestamp` to the timestamp of burning.
1831             // - `burned` to `true`.
1832             // - `nextInitialized` to `true`.
1833             _packedOwnerships[tokenId] = _packOwnershipData(
1834                 from,
1835                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) |
1836                     _nextExtraData(from, address(0), prevOwnershipPacked)
1837             );
1838 
1839             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1840             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1841                 uint256 nextTokenId = tokenId + 1;
1842                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1843                 if (_packedOwnerships[nextTokenId] == 0) {
1844                     // If the next slot is within bounds.
1845                     if (nextTokenId != _currentIndex) {
1846                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1847                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1848                     }
1849                 }
1850             }
1851         }
1852 
1853         emit Transfer(from, address(0), tokenId);
1854         _afterTokenTransfers(from, address(0), tokenId, 1);
1855 
1856         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1857         unchecked {
1858             _burnCounter++;
1859         }
1860     }
1861 
1862     // =============================================================
1863     //                     EXTRA DATA OPERATIONS
1864     // =============================================================
1865 
1866     /**
1867      * @dev Directly sets the extra data for the ownership data `index`.
1868      */
1869     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1870         uint256 packed = _packedOwnerships[index];
1871         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1872         uint256 extraDataCasted;
1873         // Cast `extraData` with assembly to avoid redundant masking.
1874         assembly {
1875             extraDataCasted := extraData
1876         }
1877         packed =
1878             (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) |
1879             (extraDataCasted << _BITPOS_EXTRA_DATA);
1880         _packedOwnerships[index] = packed;
1881     }
1882 
1883     /**
1884      * @dev Called during each token transfer to set the 24bit `extraData` field.
1885      * Intended to be overridden by the cosumer contract.
1886      *
1887      * `previousExtraData` - the value of `extraData` before transfer.
1888      *
1889      * Calling conditions:
1890      *
1891      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1892      * transferred to `to`.
1893      * - When `from` is zero, `tokenId` will be minted for `to`.
1894      * - When `to` is zero, `tokenId` will be burned by `from`.
1895      * - `from` and `to` are never both zero.
1896      */
1897     function _extraData(
1898         address from,
1899         address to,
1900         uint24 previousExtraData
1901     ) internal view virtual returns (uint24) {}
1902 
1903     /**
1904      * @dev Returns the next extra data for the packed ownership data.
1905      * The returned result is shifted into position.
1906      */
1907     function _nextExtraData(
1908         address from,
1909         address to,
1910         uint256 prevOwnershipPacked
1911     ) private view returns (uint256) {
1912         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1913         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1914     }
1915 
1916     // =============================================================
1917     //                       OTHER OPERATIONS
1918     // =============================================================
1919 
1920     /**
1921      * @dev Returns the message sender (defaults to `msg.sender`).
1922      *
1923      * If you are writing GSN compatible contracts, you need to override this function.
1924      */
1925     function _msgSenderERC721A() internal view virtual returns (address) {
1926         return msg.sender;
1927     }
1928 
1929     /**
1930      * @dev Converts a uint256 to its ASCII string decimal representation.
1931      */
1932     function _toString(uint256 value)
1933         internal
1934         pure
1935         virtual
1936         returns (string memory str)
1937     {
1938         assembly {
1939             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1940             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1941             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1942             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1943             let m := add(mload(0x40), 0xa0)
1944             // Update the free memory pointer to allocate.
1945             mstore(0x40, m)
1946             // Assign the `str` to the end.
1947             str := sub(m, 0x20)
1948             // Zeroize the slot after the string.
1949             mstore(str, 0)
1950 
1951             // Cache the end of the memory to calculate the length later.
1952             let end := str
1953 
1954             // We write the string from rightmost digit to leftmost digit.
1955             // The following is essentially a do-while loop that also handles the zero case.
1956             // prettier-ignore
1957             for { let temp := value } 1 {} {
1958                 str := sub(str, 1)
1959                 // Write the character to the pointer.
1960                 // The ASCII index of the '0' character is 48.
1961                 mstore8(str, add(48, mod(temp, 10)))
1962                 // Keep dividing `temp` until zero.
1963                 temp := div(temp, 10)
1964                 // prettier-ignore
1965                 if iszero(temp) { break }
1966             }
1967 
1968             let length := sub(end, str)
1969             // Move the pointer 32 bytes leftwards to make room for the length.
1970             str := sub(str, 0x20)
1971             // Store the length.
1972             mstore(str, length)
1973         }
1974     }
1975 }
1976 
1977 // File: contracts/IERC721AQueryable.sol
1978 
1979 // ERC721A Contracts v4.2.3
1980 // Creator: Chiru Labs
1981 
1982 pragma solidity ^0.8.4;
1983 
1984 /**
1985  * @dev Interface of ERC721AQueryable.
1986  */
1987 interface IERC721AQueryable is IERC721A {
1988     /**
1989      * Invalid query range (`start` >= `stop`).
1990      */
1991     error InvalidQueryRange();
1992 
1993     /**
1994      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1995      *
1996      * If the `tokenId` is out of bounds:
1997      *
1998      * - `addr = address(0)`
1999      * - `startTimestamp = 0`
2000      * - `burned = false`
2001      * - `extraData = 0`
2002      *
2003      * If the `tokenId` is burned:
2004      *
2005      * - `addr = <Address of owner before token was burned>`
2006      * - `startTimestamp = <Timestamp when token was burned>`
2007      * - `burned = true`
2008      * - `extraData = <Extra data when token was burned>`
2009      *
2010      * Otherwise:
2011      *
2012      * - `addr = <Address of owner>`
2013      * - `startTimestamp = <Timestamp of start of ownership>`
2014      * - `burned = false`
2015      * - `extraData = <Extra data at start of ownership>`
2016      */
2017     function explicitOwnershipOf(uint256 tokenId)
2018         external
2019         view
2020         returns (TokenOwnership memory);
2021 
2022     /**
2023      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2024      * See {ERC721AQueryable-explicitOwnershipOf}
2025      */
2026     function explicitOwnershipsOf(uint256[] memory tokenIds)
2027         external
2028         view
2029         returns (TokenOwnership[] memory);
2030 
2031     /**
2032      * @dev Returns an array of token IDs owned by `owner`,
2033      * in the range [`start`, `stop`)
2034      * (i.e. `start <= tokenId < stop`).
2035      *
2036      * This function allows for tokens to be queried if the collection
2037      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2038      *
2039      * Requirements:
2040      *
2041      * - `start < stop`
2042      */
2043     function tokensOfOwnerIn(
2044         address owner,
2045         uint256 start,
2046         uint256 stop
2047     ) external view returns (uint256[] memory);
2048 
2049     /**
2050      * @dev Returns an array of token IDs owned by `owner`.
2051      *
2052      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2053      * It is meant to be called off-chain.
2054      *
2055      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2056      * multiple smaller scans if the collection is large enough to cause
2057      * an out-of-gas error (10K collections should be fine).
2058      */
2059     function tokensOfOwner(address owner)
2060         external
2061         view
2062         returns (uint256[] memory);
2063 }
2064 
2065 // File: contracts/ERC721AQueryable.sol
2066 
2067 // ERC721A Contracts v4.2.3
2068 // Creator: Chiru Labs
2069 
2070 pragma solidity ^0.8.4;
2071 
2072 /**
2073  * @title ERC721AQueryable.
2074  *
2075  * @dev ERC721A subclass with convenience query functions.
2076  */
2077 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2078     /**
2079      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2080      *
2081      * If the `tokenId` is out of bounds:
2082      *
2083      * - `addr = address(0)`
2084      * - `startTimestamp = 0`
2085      * - `burned = false`
2086      * - `extraData = 0`
2087      *
2088      * If the `tokenId` is burned:
2089      *
2090      * - `addr = <Address of owner before token was burned>`
2091      * - `startTimestamp = <Timestamp when token was burned>`
2092      * - `burned = true`
2093      * - `extraData = <Extra data when token was burned>`
2094      *
2095      * Otherwise:
2096      *
2097      * - `addr = <Address of owner>`
2098      * - `startTimestamp = <Timestamp of start of ownership>`
2099      * - `burned = false`
2100      * - `extraData = <Extra data at start of ownership>`
2101      */
2102     function explicitOwnershipOf(uint256 tokenId)
2103         public
2104         view
2105         virtual
2106         override
2107         returns (TokenOwnership memory)
2108     {
2109         TokenOwnership memory ownership;
2110         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2111             return ownership;
2112         }
2113         ownership = _ownershipAt(tokenId);
2114         if (ownership.burned) {
2115             return ownership;
2116         }
2117         return _ownershipOf(tokenId);
2118     }
2119 
2120     /**
2121      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2122      * See {ERC721AQueryable-explicitOwnershipOf}
2123      */
2124     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2125         external
2126         view
2127         virtual
2128         override
2129         returns (TokenOwnership[] memory)
2130     {
2131         unchecked {
2132             uint256 tokenIdsLength = tokenIds.length;
2133             TokenOwnership[] memory ownerships = new TokenOwnership[](
2134                 tokenIdsLength
2135             );
2136             for (uint256 i; i != tokenIdsLength; ++i) {
2137                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2138             }
2139             return ownerships;
2140         }
2141     }
2142 
2143     /**
2144      * @dev Returns an array of token IDs owned by `owner`,
2145      * in the range [`start`, `stop`)
2146      * (i.e. `start <= tokenId < stop`).
2147      *
2148      * This function allows for tokens to be queried if the collection
2149      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2150      *
2151      * Requirements:
2152      *
2153      * - `start < stop`
2154      */
2155     function tokensOfOwnerIn(
2156         address owner,
2157         uint256 start,
2158         uint256 stop
2159     ) external view virtual override returns (uint256[] memory) {
2160         unchecked {
2161             if (start >= stop) revert InvalidQueryRange();
2162             uint256 tokenIdsIdx;
2163             uint256 stopLimit = _nextTokenId();
2164             // Set `start = max(start, _startTokenId())`.
2165             if (start < _startTokenId()) {
2166                 start = _startTokenId();
2167             }
2168             // Set `stop = min(stop, stopLimit)`.
2169             if (stop > stopLimit) {
2170                 stop = stopLimit;
2171             }
2172             uint256 tokenIdsMaxLength = balanceOf(owner);
2173             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2174             // to cater for cases where `balanceOf(owner)` is too big.
2175             if (start < stop) {
2176                 uint256 rangeLength = stop - start;
2177                 if (rangeLength < tokenIdsMaxLength) {
2178                     tokenIdsMaxLength = rangeLength;
2179                 }
2180             } else {
2181                 tokenIdsMaxLength = 0;
2182             }
2183             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2184             if (tokenIdsMaxLength == 0) {
2185                 return tokenIds;
2186             }
2187             // We need to call `explicitOwnershipOf(start)`,
2188             // because the slot at `start` may not be initialized.
2189             TokenOwnership memory ownership = explicitOwnershipOf(start);
2190             address currOwnershipAddr;
2191             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2192             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2193             if (!ownership.burned) {
2194                 currOwnershipAddr = ownership.addr;
2195             }
2196             for (
2197                 uint256 i = start;
2198                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
2199                 ++i
2200             ) {
2201                 ownership = _ownershipAt(i);
2202                 if (ownership.burned) {
2203                     continue;
2204                 }
2205                 if (ownership.addr != address(0)) {
2206                     currOwnershipAddr = ownership.addr;
2207                 }
2208                 if (currOwnershipAddr == owner) {
2209                     tokenIds[tokenIdsIdx++] = i;
2210                 }
2211             }
2212             // Downsize the array to fit.
2213             assembly {
2214                 mstore(tokenIds, tokenIdsIdx)
2215             }
2216             return tokenIds;
2217         }
2218     }
2219 
2220     /**
2221      * @dev Returns an array of token IDs owned by `owner`.
2222      *
2223      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2224      * It is meant to be called off-chain.
2225      *
2226      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2227      * multiple smaller scans if the collection is large enough to cause
2228      * an out-of-gas error (10K collections should be fine).
2229      */
2230     function tokensOfOwner(address owner)
2231         external
2232         view
2233         virtual
2234         override
2235         returns (uint256[] memory)
2236     {
2237         unchecked {
2238             uint256 tokenIdsIdx;
2239             address currOwnershipAddr;
2240             uint256 tokenIdsLength = balanceOf(owner);
2241             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2242             TokenOwnership memory ownership;
2243             for (
2244                 uint256 i = _startTokenId();
2245                 tokenIdsIdx != tokenIdsLength;
2246                 ++i
2247             ) {
2248                 ownership = _ownershipAt(i);
2249                 if (ownership.burned) {
2250                     continue;
2251                 }
2252                 if (ownership.addr != address(0)) {
2253                     currOwnershipAddr = ownership.addr;
2254                 }
2255                 if (currOwnershipAddr == owner) {
2256                     tokenIds[tokenIdsIdx++] = i;
2257                 }
2258             }
2259             return tokenIds;
2260         }
2261     }
2262 }
2263 
2264 // File: contracts/SpaceRidersDockable.sol
2265 
2266 pragma solidity >=0.8.12 <0.9.0;
2267 
2268 interface StarToken {
2269     function balanceOf(address _address)
2270         external
2271         view
2272         returns (uint256 balance);
2273 
2274     function spend(address _from, uint256 _amount) external;
2275 
2276     function mint(address to, uint256 amount) external;
2277 }
2278 
2279 interface SpaceRiders {
2280     function balanceOf(address owner) external view returns (uint256 balance);
2281 }
2282 
2283 interface SpaceRidersRewards {
2284     function getReward(address _to, uint256 _dockingPeriod) external;
2285 }
2286 
2287 error NoSpaceRider();
2288 error OnlyBoardOwner();
2289 error BoardDocked();
2290 error BoardUndocked();
2291 error BoardDockingClosed();
2292 error WalletDocked();
2293 error TokenClaimed();
2294 error WalletClaimed();
2295 error TransferNotAllowedBoardDocked();
2296 error DockingPeriodDoesNotExist();
2297 error DockingPeriodExists();
2298 
2299 abstract contract SpaceRidersDockable is
2300     ERC721A,
2301     ERC721AQueryable,
2302     Ownable,
2303     ReentrancyGuard
2304 {
2305     SpaceRiders public spaceRiders =
2306         SpaceRiders(0xC9d198089D6c31d0Ca5Cc5B92C97a57A97BBfdE2);
2307     StarToken public starToken =
2308         StarToken(0xDaa58A1851672a6490E2bb9Fdc8868918cDd86e6);
2309     SpaceRidersRewards public spaceRidersRewards;
2310 
2311     struct Dock {
2312         uint256 ts;
2313         uint256 tokenId;
2314         uint256 period;
2315         uint256 periodLength;
2316     }
2317     struct DockingPeriod {
2318         uint256 periodId;
2319         uint256 periodLength;
2320         uint256 rewardTokenId;
2321         uint256 starRewardAmount;
2322         bool isOpen;
2323     }
2324     mapping(uint256 => uint256) private dockingStarted;
2325     mapping(uint256 => mapping(uint256 => bool)) public rewardClaimed;
2326     mapping(uint256 => DockingPeriod) public dockingPeriods;
2327     mapping(address => Dock) public dockedWallets;
2328     mapping(address => mapping(uint256 => bool)) public walletClaimed;
2329 
2330     event Docked(uint256 indexed tokenId);
2331     event Undocked(uint256 indexed tokenId);
2332     event Terminated(uint256 indexed tokenId);
2333 
2334     constructor(string memory _name, string memory _symbol)
2335         ERC721A(_name, _symbol)
2336     {}
2337 
2338     function dockBoard(uint256 tokenId, uint256 dockingPeriodId) external {
2339         if (dockingPeriods[dockingPeriodId].periodId == 0)
2340             revert DockingPeriodDoesNotExist();
2341         if (!canDock(dockingPeriodId)) revert BoardDockingClosed();
2342         if (dockingStarted[tokenId] != 0) revert BoardDocked();
2343         if (dockedWallets[msg.sender].tokenId != 0) revert WalletDocked();
2344         if (rewardClaimed[tokenId][dockingPeriodId]) revert TokenClaimed();
2345         if (walletClaimed[msg.sender][dockingPeriodId]) revert WalletClaimed();
2346         if (spaceRiders.balanceOf(msg.sender) == 0) revert NoSpaceRider();
2347 
2348         toggleBoardDocking(tokenId, dockingPeriodId);
2349     }
2350 
2351     function undockBoard(uint256 tokenId) external {
2352         if (dockingStarted[tokenId] == 0) revert BoardUndocked();
2353         toggleBoardDocking(tokenId, 0);
2354     }
2355 
2356     function canDock(uint256 _dockingPeriodId) public view returns (bool) {
2357         return dockingPeriods[_dockingPeriodId].isOpen;
2358     }
2359 
2360     function dockedTimeOfToken(uint256 tokenId)
2361         public
2362         view
2363         returns (
2364             uint256 current,
2365             uint256 period,
2366             uint256 periodLength
2367         )
2368     {
2369         uint256 start = dockingStarted[tokenId];
2370         if (start != 0) {
2371             return (
2372                 block.timestamp - start,
2373                 dockedWallets[_ownershipOf(tokenId).addr].period,
2374                 dockedWallets[_ownershipOf(tokenId).addr].periodLength
2375             );
2376         }
2377     }
2378 
2379     /* -------
2380     Owner Functions
2381     ------- */
2382     function setSpaceRiders(address _contract) external onlyOwner {
2383         spaceRiders = SpaceRiders(_contract);
2384     }
2385 
2386     function setStarToken(address _contract) external onlyOwner {
2387         starToken = StarToken(_contract);
2388     }
2389 
2390     function setRewards(address _contract) external onlyOwner {
2391         spaceRidersRewards = SpaceRidersRewards(_contract);
2392     }
2393 
2394     function setDockingPeriodDetails(
2395         uint256 _dockingPeriodId,
2396         uint256 _dockingPeriodLength,
2397         uint256 _rewardTokenId,
2398         uint256 _starRewardAmount,
2399         bool _isOpen
2400     ) external onlyOwner {
2401         if (dockingPeriods[_dockingPeriodId].periodId != 0)
2402             revert DockingPeriodExists();
2403         dockingPeriods[_dockingPeriodId] = DockingPeriod(
2404             uint256(_dockingPeriodId),
2405             uint256(_dockingPeriodLength),
2406             uint256(_rewardTokenId),
2407             uint256(_starRewardAmount),
2408             bool(_isOpen)
2409         );
2410     }
2411 
2412     function updateDockingPeriodDetails(
2413         uint256 _dockingPeriodId,
2414         uint256 _dockingPeriodLength,
2415         uint256 _rewardTokenId,
2416         uint256 _starRewardAmount
2417     ) external onlyOwner {
2418         if (dockingPeriods[_dockingPeriodId].periodId == 0)
2419             revert DockingPeriodDoesNotExist();
2420         dockingPeriods[_dockingPeriodId].periodLength = _dockingPeriodLength;
2421         dockingPeriods[_dockingPeriodId].rewardTokenId = _rewardTokenId;
2422         dockingPeriods[_dockingPeriodId].starRewardAmount = _starRewardAmount;
2423     }
2424 
2425     function toggleCanDock(uint256 _dockingPeriodId) external onlyOwner {
2426         if (dockingPeriods[_dockingPeriodId].periodId == 0)
2427             revert DockingPeriodDoesNotExist();
2428         dockingPeriods[_dockingPeriodId].isOpen = !dockingPeriods[
2429             _dockingPeriodId
2430         ].isOpen;
2431     }
2432 
2433     /**
2434     @dev Allows the owner of the contract to terminate docking for multiple token Ids.
2435     @param tokenIds The token Ids to be terminated from docking.
2436     */
2437     function terminateFromDock(uint256[] calldata tokenIds) external onlyOwner {
2438         for (uint256 i = 0; i < tokenIds.length; ++i) {
2439             uint256 tokenId = tokenIds[i];
2440             if (dockingStarted[tokenId] == 0) revert BoardUndocked();
2441 
2442             address owner = _ownershipOf(tokenId).addr;
2443             (
2444                 uint256 dockedTime,
2445                 uint256 periodId,
2446                 uint256 periodLength
2447             ) = dockedTimeOfToken(tokenId);
2448             if (
2449                 dockedTime > periodLength &&
2450                 !rewardClaimed[tokenId][periodId] &&
2451                 !walletClaimed[owner][periodId]
2452             ) {
2453                 dockingStarted[tokenId] = 0;
2454                 walletClaimed[owner][periodId] = true;
2455                 rewardClaimed[tokenId][periodId] = true;
2456                 delete dockedWallets[owner];
2457                 uint256 rewardTokenId = dockingPeriods[periodId].rewardTokenId;
2458                 uint256 starRewardAmount = dockingPeriods[periodId]
2459                     .starRewardAmount;
2460                 if (rewardTokenId != 0) {
2461                     spaceRidersRewards.getReward(owner, rewardTokenId);
2462                 }
2463                 if (starRewardAmount != 0) {
2464                     starToken.mint(owner, starRewardAmount);
2465                 }
2466             } else {
2467                 dockingStarted[tokenId] = 0;
2468                 delete dockedWallets[owner];
2469             }
2470 
2471             emit Undocked(tokenId);
2472             emit Terminated(tokenId);
2473         }
2474     }
2475 
2476     /* -------
2477     Internal Functions
2478     ------- */
2479     function _startTokenId() internal view virtual override returns (uint256) {
2480         return 1;
2481     }
2482 
2483     function toggleBoardDocking(uint256 tokenId, uint256 dockingPeriodId)
2484         private
2485     {
2486         if (_ownershipOf(tokenId).addr != msg.sender) revert OnlyBoardOwner();
2487         if (dockingStarted[tokenId] == 0) {
2488             uint256 timestamp = block.timestamp;
2489             dockingStarted[tokenId] = timestamp;
2490             dockedWallets[msg.sender] = Dock(
2491                 uint32(timestamp),
2492                 uint256(tokenId),
2493                 uint256(dockingPeriodId),
2494                 uint256(dockingPeriods[dockingPeriodId].periodLength)
2495             );
2496             emit Docked(tokenId);
2497         } else {
2498             (
2499                 uint256 dockedTime,
2500                 uint256 periodId,
2501                 uint256 periodLength
2502             ) = dockedTimeOfToken(tokenId);
2503             if (
2504                 dockedTime > periodLength &&
2505                 !rewardClaimed[tokenId][periodId] &&
2506                 !walletClaimed[msg.sender][periodId]
2507             ) {
2508                 dockingStarted[tokenId] = 0;
2509                 walletClaimed[msg.sender][periodId] = true;
2510                 rewardClaimed[tokenId][periodId] = true;
2511                 delete dockedWallets[msg.sender];
2512                 uint256 rewardTokenId = dockingPeriods[periodId].rewardTokenId;
2513                 uint256 starRewardAmount = dockingPeriods[periodId]
2514                     .starRewardAmount;
2515                 if (rewardTokenId != 0) {
2516                     spaceRidersRewards.getReward(msg.sender, rewardTokenId);
2517                 }
2518                 if (starRewardAmount != 0) {
2519                     starToken.mint(msg.sender, starRewardAmount);
2520                 }
2521             } else {
2522                 dockingStarted[tokenId] = 0;
2523                 delete dockedWallets[msg.sender];
2524             }
2525             emit Undocked(tokenId);
2526         }
2527     }
2528 
2529     /**
2530     @dev Block transfers while docked.
2531      */
2532     function _beforeTokenTransfers(
2533         address from,
2534         address to,
2535         uint256 startTokenId,
2536         uint256 quantity
2537     ) internal virtual override {
2538         super._beforeTokenTransfers(from, to, startTokenId, quantity);
2539         uint256 tokenId = startTokenId;
2540         for (uint256 end = tokenId + quantity; tokenId != end; ++tokenId) {
2541             if (dockingStarted[tokenId] > 0)
2542                 revert TransferNotAllowedBoardDocked();
2543         }
2544     }
2545 }
2546 
2547 // File: contracts/SpaceRidersGalacticForge.sol
2548 
2549 pragma solidity >=0.8.12 <0.9.0;
2550 
2551 interface OgPass {
2552     function balanceOf(address owner) external view returns (uint256 balance);
2553 }
2554 
2555 error Paused();
2556 error EthSalePaused();
2557 error MaxMintAmountExceed();
2558 error SupplyExceeded();
2559 error NotWhitelistedForBoard();
2560 error InsufficientStar();
2561 error InvalidValue();
2562 error InvalidTokenType();
2563 error TokenDoesntExist();
2564 error NewSupplyToLow();
2565 error NoBalanceToWithdraw();
2566 error WithdrawFailed();
2567 
2568 contract SpaceRidersGalacticForge is SpaceRidersDockable {
2569     using MerkleProof for bytes32[];
2570 
2571     uint256 private constant RIDER = 0;
2572     uint256 private constant CELESTIAL = 1;
2573     uint256 private constant SRX = 2;
2574     uint256 private constant ANCIENT = 3;
2575     uint256 public cost = 0.02 ether;
2576     uint256[4] public mintRates = [
2577         250 ether,
2578         1000 ether,
2579         5000 ether,
2580         10000 ether
2581     ];
2582     uint256[4] public minted = [0, 0, 0, 0];
2583     uint256[4] public supplies = [2973, 250, 90, 20];
2584     bytes32[4] private merkleRoots;
2585     string public baseURI;
2586     uint256 public mintStatus = 0;
2587     mapping(uint256 => uint256) private _tokenTypes;
2588 
2589     OgPass public ogPass = OgPass(0xBa2aa4B18752E75e210FBa0424e565AF3AFb8fC7);
2590 
2591     event NewBoardMinted(address sender);
2592 
2593     constructor(
2594         string memory _name,
2595         string memory _symbol,
2596         string memory _baseURI
2597     ) SpaceRidersDockable(_name, _symbol) {
2598         setBaseURI(_baseURI);
2599     }
2600 
2601     function mint(uint256 _id, bytes32[] calldata proof) external {
2602         if (_id > supplies.length || _id < 0) revert InvalidTokenType();
2603         if (mintStatus == 0) revert Paused();
2604         if (
2605             !proof.verify(
2606                 merkleRoots[_id],
2607                 keccak256(abi.encodePacked(msg.sender))
2608             )
2609         ) revert NotWhitelistedForBoard();
2610         _validateMint(_id);
2611         uint256 starCost = (
2612             ogPass.balanceOf(msg.sender) > 0
2613                 ? mintRates[_id] / 2
2614                 : mintRates[_id]
2615         );
2616         if (starToken.balanceOf(msg.sender) < starCost)
2617             revert InsufficientStar();
2618         starToken.spend(msg.sender, starCost);
2619         _processMint(_id);
2620     }
2621 
2622     function mintWithEth() external payable {
2623         if (mintStatus != 2) revert EthSalePaused();
2624         if (msg.value != cost) revert InvalidValue();
2625         _validateMint(RIDER);
2626         _processMint(RIDER);
2627     }
2628 
2629     /* -------
2630     Internal Functions
2631     ------- */
2632     function _validateMint(uint256 _tokenTypeId) internal view {
2633         if (spaceRiders.balanceOf(msg.sender) == 0) revert NoSpaceRider();
2634         if (minted[_tokenTypeId] + 1 > supplies[_tokenTypeId])
2635             revert SupplyExceeded();
2636         if (mintedTotalOfAddress(msg.sender) > 0) revert MaxMintAmountExceed();
2637     }
2638 
2639     function _processMint(uint256 _tokenTypeId) internal {
2640         _tokenTypes[_nextTokenId()] = _tokenTypeId;
2641         ++minted[_tokenTypeId];
2642         _setAux(msg.sender, 1);
2643         _safeMint(msg.sender, 1);
2644         emit NewBoardMinted(msg.sender);
2645     }
2646 
2647     /* -------
2648     View Functions
2649     ------- */
2650     function tokenURI(uint256 _tokenId)
2651         public
2652         view
2653         virtual
2654         override(ERC721A, IERC721A)
2655         returns (string memory)
2656     {
2657         if (!_exists(_tokenId)) revert OwnerQueryForNonexistentToken();
2658         return
2659             bytes(baseURI).length > 0
2660                 ? string(
2661                     abi.encodePacked(baseURI, _toString(_tokenId), ".json")
2662                 )
2663                 : "";
2664     }
2665 
2666     function mintedTotalOfAddress(address _address)
2667         public
2668         view
2669         returns (uint64)
2670     {
2671         return uint64(_getAux(_address));
2672     }
2673 
2674     function remainingSupplyOfTokenType(uint256 _id)
2675         public
2676         view
2677         returns (uint256)
2678     {
2679         return supplies[_id] - minted[_id];
2680     }
2681 
2682     function tokenType(uint256 _tokenId) public view returns (uint256) {
2683         if (!_exists(_tokenId)) revert OwnerQueryForNonexistentToken();
2684         return _tokenTypes[_tokenId] + 1;
2685     }
2686 
2687     /* -------
2688     Owner Functions
2689     ------- */
2690     function setOgPass(address _contract) external onlyOwner {
2691         ogPass = OgPass(_contract);
2692     }
2693 
2694     function setBaseURI(string memory _baseURI) public onlyOwner {
2695         baseURI = _baseURI;
2696     }
2697 
2698     function setMintStatus(uint256 _mintStatus) external onlyOwner {
2699         mintStatus = _mintStatus;
2700     }
2701 
2702     function setMintRates(uint256[4] calldata _mintRates) external onlyOwner {
2703         mintRates = _mintRates;
2704     }
2705 
2706     function setCost(uint256 _newCost) external onlyOwner {
2707         cost = _newCost;
2708     }
2709 
2710     function setSupplies(uint256[4] calldata _supplies) external onlyOwner {
2711         for (uint256 i = 0; i < 4; ++i) {
2712             if (_supplies[i] < minted[i]) revert NewSupplyToLow();
2713             supplies[i] = _supplies[i];
2714         }
2715     }
2716 
2717     function setMerkleRootForTokenTypes(bytes32[4] calldata _merkleRoots)
2718         external
2719         onlyOwner
2720     {
2721         merkleRoots = _merkleRoots;
2722     }
2723 
2724     function mintMultipleToAddress(
2725         uint256 _id,
2726         uint256 _amount,
2727         address _address
2728     ) external onlyOwner {
2729         if (_id > supplies.length || _id < 0) revert InvalidTokenType();
2730         if (_amount > remainingSupplyOfTokenType(_id)) revert SupplyExceeded();
2731 
2732         uint256 mintIndex = _nextTokenId();
2733         for (
2734             uint256 nextTokenId = mintIndex;
2735             nextTokenId < (mintIndex + _amount);
2736             ++nextTokenId
2737         ) {
2738             _tokenTypes[nextTokenId] = _id;
2739         }
2740         minted[_id] += _amount;
2741         _safeMint(_address, _amount);
2742     }
2743 
2744     function withdraw() public payable onlyOwner {
2745         (bool success, ) = payable(0x2A76bAA2F2cFB1b17aE672C995B3C41398e86cCD)
2746             .call{value: address(this).balance}("");
2747         if (!success) revert WithdrawFailed();
2748     }
2749 }