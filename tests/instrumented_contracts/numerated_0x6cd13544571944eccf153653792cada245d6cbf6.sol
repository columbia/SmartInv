1 // File: testnet_TOA/talesofaleko/lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 
72     /**
73      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
74      * `nonReentrant` function in the call stack.
75      */
76     function _reentrancyGuardEntered() internal view returns (bool) {
77         return _status == _ENTERED;
78     }
79 }
80 
81 // File: testnet_TOA/talesofaleko/lib/openzeppelin-contracts/contracts/utils/Context.sol
82 
83 
84 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Provides information about the current execution context, including the
90  * sender of the transaction and its data. While these are generally available
91  * via msg.sender and msg.data, they should not be accessed in such a direct
92  * manner, since when dealing with meta-transactions the account sending and
93  * paying for execution may not be the actual sender (as far as an application
94  * is concerned).
95  *
96  * This contract is only required for intermediate, library-like contracts.
97  */
98 abstract contract Context {
99     function _msgSender() internal view virtual returns (address) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view virtual returns (bytes calldata) {
104         return msg.data;
105     }
106 }
107 
108 // File: testnet_TOA/talesofaleko/lib/openzeppelin-contracts/contracts/access/Ownable.sol
109 
110 
111 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 
116 /**
117  * @dev Contract module which provides a basic access control mechanism, where
118  * there is an account (an owner) that can be granted exclusive access to
119  * specific functions.
120  *
121  * By default, the owner account will be the one that deploys the contract. This
122  * can later be changed with {transferOwnership}.
123  *
124  * This module is used through inheritance. It will make available the modifier
125  * `onlyOwner`, which can be applied to your functions to restrict their use to
126  * the owner.
127  */
128 abstract contract Ownable is Context {
129     address private _owner;
130 
131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133     /**
134      * @dev Initializes the contract setting the deployer as the initial owner.
135      */
136     constructor() {
137         _transferOwnership(_msgSender());
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         _checkOwner();
145         _;
146     }
147 
148     /**
149      * @dev Returns the address of the current owner.
150      */
151     function owner() public view virtual returns (address) {
152         return _owner;
153     }
154 
155     /**
156      * @dev Throws if the sender is not the owner.
157      */
158     function _checkOwner() internal view virtual {
159         require(owner() == _msgSender(), "Ownable: caller is not the owner");
160     }
161 
162     /**
163      * @dev Leaves the contract without owner. It will not be possible to call
164      * `onlyOwner` functions. Can only be called by the current owner.
165      *
166      * NOTE: Renouncing ownership will leave the contract without an owner,
167      * thereby disabling any functionality that is only available to the owner.
168      */
169     function renounceOwnership() public virtual onlyOwner {
170         _transferOwnership(address(0));
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      * Can only be called by the current owner.
176      */
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         _transferOwnership(newOwner);
180     }
181 
182     /**
183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
184      * Internal function without access restriction.
185      */
186     function _transferOwnership(address newOwner) internal virtual {
187         address oldOwner = _owner;
188         _owner = newOwner;
189         emit OwnershipTransferred(oldOwner, newOwner);
190     }
191 }
192 
193 // File: testnet_TOA/talesofaleko/lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol
194 
195 
196 // OpenZeppelin Contracts (last updated v4.9.2) (utils/cryptography/MerkleProof.sol)
197 
198 pragma solidity ^0.8.0;
199 
200 /**
201  * @dev These functions deal with verification of Merkle Tree proofs.
202  *
203  * The tree and the proofs can be generated using our
204  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
205  * You will find a quickstart guide in the readme.
206  *
207  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
208  * hashing, or use a hash function other than keccak256 for hashing leaves.
209  * This is because the concatenation of a sorted pair of internal nodes in
210  * the merkle tree could be reinterpreted as a leaf value.
211  * OpenZeppelin's JavaScript library generates merkle trees that are safe
212  * against this attack out of the box.
213  */
214 library MerkleProof {
215     /**
216      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
217      * defined by `root`. For this, a `proof` must be provided, containing
218      * sibling hashes on the branch from the leaf to the root of the tree. Each
219      * pair of leaves and each pair of pre-images are assumed to be sorted.
220      */
221     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
222         return processProof(proof, leaf) == root;
223     }
224 
225     /**
226      * @dev Calldata version of {verify}
227      *
228      * _Available since v4.7._
229      */
230     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
231         return processProofCalldata(proof, leaf) == root;
232     }
233 
234     /**
235      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
236      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
237      * hash matches the root of the tree. When processing the proof, the pairs
238      * of leafs & pre-images are assumed to be sorted.
239      *
240      * _Available since v4.4._
241      */
242     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
243         bytes32 computedHash = leaf;
244         for (uint256 i = 0; i < proof.length; i++) {
245             computedHash = _hashPair(computedHash, proof[i]);
246         }
247         return computedHash;
248     }
249 
250     /**
251      * @dev Calldata version of {processProof}
252      *
253      * _Available since v4.7._
254      */
255     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
256         bytes32 computedHash = leaf;
257         for (uint256 i = 0; i < proof.length; i++) {
258             computedHash = _hashPair(computedHash, proof[i]);
259         }
260         return computedHash;
261     }
262 
263     /**
264      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
265      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
266      *
267      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
268      *
269      * _Available since v4.7._
270      */
271     function multiProofVerify(
272         bytes32[] memory proof,
273         bool[] memory proofFlags,
274         bytes32 root,
275         bytes32[] memory leaves
276     ) internal pure returns (bool) {
277         return processMultiProof(proof, proofFlags, leaves) == root;
278     }
279 
280     /**
281      * @dev Calldata version of {multiProofVerify}
282      *
283      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
284      *
285      * _Available since v4.7._
286      */
287     function multiProofVerifyCalldata(
288         bytes32[] calldata proof,
289         bool[] calldata proofFlags,
290         bytes32 root,
291         bytes32[] memory leaves
292     ) internal pure returns (bool) {
293         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
294     }
295 
296     /**
297      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
298      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
299      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
300      * respectively.
301      *
302      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
303      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
304      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
305      *
306      * _Available since v4.7._
307      */
308     function processMultiProof(
309         bytes32[] memory proof,
310         bool[] memory proofFlags,
311         bytes32[] memory leaves
312     ) internal pure returns (bytes32 merkleRoot) {
313         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
314         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
315         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
316         // the merkle tree.
317         uint256 leavesLen = leaves.length;
318         uint256 proofLen = proof.length;
319         uint256 totalHashes = proofFlags.length;
320 
321         // Check proof validity.
322         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
323 
324         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
325         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
326         bytes32[] memory hashes = new bytes32[](totalHashes);
327         uint256 leafPos = 0;
328         uint256 hashPos = 0;
329         uint256 proofPos = 0;
330         // At each step, we compute the next hash using two values:
331         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
332         //   get the next hash.
333         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
334         //   `proof` array.
335         for (uint256 i = 0; i < totalHashes; i++) {
336             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
337             bytes32 b = proofFlags[i]
338                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
339                 : proof[proofPos++];
340             hashes[i] = _hashPair(a, b);
341         }
342 
343         if (totalHashes > 0) {
344             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
345             unchecked {
346                 return hashes[totalHashes - 1];
347             }
348         } else if (leavesLen > 0) {
349             return leaves[0];
350         } else {
351             return proof[0];
352         }
353     }
354 
355     /**
356      * @dev Calldata version of {processMultiProof}.
357      *
358      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
359      *
360      * _Available since v4.7._
361      */
362     function processMultiProofCalldata(
363         bytes32[] calldata proof,
364         bool[] calldata proofFlags,
365         bytes32[] memory leaves
366     ) internal pure returns (bytes32 merkleRoot) {
367         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
368         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
369         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
370         // the merkle tree.
371         uint256 leavesLen = leaves.length;
372         uint256 proofLen = proof.length;
373         uint256 totalHashes = proofFlags.length;
374 
375         // Check proof validity.
376         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
377 
378         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
379         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
380         bytes32[] memory hashes = new bytes32[](totalHashes);
381         uint256 leafPos = 0;
382         uint256 hashPos = 0;
383         uint256 proofPos = 0;
384         // At each step, we compute the next hash using two values:
385         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
386         //   get the next hash.
387         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
388         //   `proof` array.
389         for (uint256 i = 0; i < totalHashes; i++) {
390             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
391             bytes32 b = proofFlags[i]
392                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
393                 : proof[proofPos++];
394             hashes[i] = _hashPair(a, b);
395         }
396 
397         if (totalHashes > 0) {
398             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
399             unchecked {
400                 return hashes[totalHashes - 1];
401             }
402         } else if (leavesLen > 0) {
403             return leaves[0];
404         } else {
405             return proof[0];
406         }
407     }
408 
409     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
410         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
411     }
412 
413     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
414         /// @solidity memory-safe-assembly
415         assembly {
416             mstore(0x00, a)
417             mstore(0x20, b)
418             value := keccak256(0x00, 0x40)
419         }
420     }
421 }
422 
423 // File: testnet_TOA/talesofaleko/lib/ERC721A/contracts/IERC721A.sol
424 
425 
426 // ERC721A Contracts v4.2.3
427 // Creator: Chiru Labs
428 
429 pragma solidity ^0.8.4;
430 
431 /**
432  * @dev Interface of ERC721A.
433  */
434 interface IERC721A {
435     /**
436      * The caller must own the token or be an approved operator.
437      */
438     error ApprovalCallerNotOwnerNorApproved();
439 
440     /**
441      * The token does not exist.
442      */
443     error ApprovalQueryForNonexistentToken();
444 
445     /**
446      * Cannot query the balance for the zero address.
447      */
448     error BalanceQueryForZeroAddress();
449 
450     /**
451      * Cannot mint to the zero address.
452      */
453     error MintToZeroAddress();
454 
455     /**
456      * The quantity of tokens minted must be more than zero.
457      */
458     error MintZeroQuantity();
459 
460     /**
461      * The token does not exist.
462      */
463     error OwnerQueryForNonexistentToken();
464 
465     /**
466      * The caller must own the token or be an approved operator.
467      */
468     error TransferCallerNotOwnerNorApproved();
469 
470     /**
471      * The token must be owned by `from`.
472      */
473     error TransferFromIncorrectOwner();
474 
475     /**
476      * Cannot safely transfer to a contract that does not implement the
477      * ERC721Receiver interface.
478      */
479     error TransferToNonERC721ReceiverImplementer();
480 
481     /**
482      * Cannot transfer to the zero address.
483      */
484     error TransferToZeroAddress();
485 
486     /**
487      * The token does not exist.
488      */
489     error URIQueryForNonexistentToken();
490 
491     /**
492      * The `quantity` minted with ERC2309 exceeds the safety limit.
493      */
494     error MintERC2309QuantityExceedsLimit();
495 
496     /**
497      * The `extraData` cannot be set on an unintialized ownership slot.
498      */
499     error OwnershipNotInitializedForExtraData();
500 
501     // =============================================================
502     //                            STRUCTS
503     // =============================================================
504 
505     struct TokenOwnership {
506         // The address of the owner.
507         address addr;
508         // Stores the start time of ownership with minimal overhead for tokenomics.
509         uint64 startTimestamp;
510         // Whether the token has been burned.
511         bool burned;
512         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
513         uint24 extraData;
514     }
515 
516     // =============================================================
517     //                         TOKEN COUNTERS
518     // =============================================================
519 
520     /**
521      * @dev Returns the total number of tokens in existence.
522      * Burned tokens will reduce the count.
523      * To get the total number of tokens minted, please see {_totalMinted}.
524      */
525     function totalSupply() external view returns (uint256);
526 
527     // =============================================================
528     //                            IERC165
529     // =============================================================
530 
531     /**
532      * @dev Returns true if this contract implements the interface defined by
533      * `interfaceId`. See the corresponding
534      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
535      * to learn more about how these ids are created.
536      *
537      * This function call must use less than 30000 gas.
538      */
539     function supportsInterface(bytes4 interfaceId) external view returns (bool);
540 
541     // =============================================================
542     //                            IERC721
543     // =============================================================
544 
545     /**
546      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
547      */
548     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
549 
550     /**
551      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
552      */
553     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
554 
555     /**
556      * @dev Emitted when `owner` enables or disables
557      * (`approved`) `operator` to manage all of its assets.
558      */
559     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
560 
561     /**
562      * @dev Returns the number of tokens in `owner`'s account.
563      */
564     function balanceOf(address owner) external view returns (uint256 balance);
565 
566     /**
567      * @dev Returns the owner of the `tokenId` token.
568      *
569      * Requirements:
570      *
571      * - `tokenId` must exist.
572      */
573     function ownerOf(uint256 tokenId) external view returns (address owner);
574 
575     /**
576      * @dev Safely transfers `tokenId` token from `from` to `to`,
577      * checking first that contract recipients are aware of the ERC721 protocol
578      * to prevent tokens from being forever locked.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must exist and be owned by `from`.
585      * - If the caller is not `from`, it must be have been allowed to move
586      * this token by either {approve} or {setApprovalForAll}.
587      * - If `to` refers to a smart contract, it must implement
588      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
589      *
590      * Emits a {Transfer} event.
591      */
592     function safeTransferFrom(
593         address from,
594         address to,
595         uint256 tokenId,
596         bytes calldata data
597     ) external payable;
598 
599     /**
600      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
601      */
602     function safeTransferFrom(
603         address from,
604         address to,
605         uint256 tokenId
606     ) external payable;
607 
608     /**
609      * @dev Transfers `tokenId` from `from` to `to`.
610      *
611      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
612      * whenever possible.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must be owned by `from`.
619      * - If the caller is not `from`, it must be approved to move this token
620      * by either {approve} or {setApprovalForAll}.
621      *
622      * Emits a {Transfer} event.
623      */
624     function transferFrom(
625         address from,
626         address to,
627         uint256 tokenId
628     ) external payable;
629 
630     /**
631      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
632      * The approval is cleared when the token is transferred.
633      *
634      * Only a single account can be approved at a time, so approving the
635      * zero address clears previous approvals.
636      *
637      * Requirements:
638      *
639      * - The caller must own the token or be an approved operator.
640      * - `tokenId` must exist.
641      *
642      * Emits an {Approval} event.
643      */
644     function approve(address to, uint256 tokenId) external payable;
645 
646     /**
647      * @dev Approve or remove `operator` as an operator for the caller.
648      * Operators can call {transferFrom} or {safeTransferFrom}
649      * for any token owned by the caller.
650      *
651      * Requirements:
652      *
653      * - The `operator` cannot be the caller.
654      *
655      * Emits an {ApprovalForAll} event.
656      */
657     function setApprovalForAll(address operator, bool _approved) external;
658 
659     /**
660      * @dev Returns the account approved for `tokenId` token.
661      *
662      * Requirements:
663      *
664      * - `tokenId` must exist.
665      */
666     function getApproved(uint256 tokenId) external view returns (address operator);
667 
668     /**
669      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
670      *
671      * See {setApprovalForAll}.
672      */
673     function isApprovedForAll(address owner, address operator) external view returns (bool);
674 
675     // =============================================================
676     //                        IERC721Metadata
677     // =============================================================
678 
679     /**
680      * @dev Returns the token collection name.
681      */
682     function name() external view returns (string memory);
683 
684     /**
685      * @dev Returns the token collection symbol.
686      */
687     function symbol() external view returns (string memory);
688 
689     /**
690      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
691      */
692     function tokenURI(uint256 tokenId) external view returns (string memory);
693 
694     // =============================================================
695     //                           IERC2309
696     // =============================================================
697 
698     /**
699      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
700      * (inclusive) is transferred from `from` to `to`, as defined in the
701      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
702      *
703      * See {_mintERC2309} for more details.
704      */
705     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
706 }
707 
708 // File: testnet_TOA/talesofaleko/lib/ERC721A/contracts/extensions/IERC721ABurnable.sol
709 
710 
711 // ERC721A Contracts v4.2.3
712 // Creator: Chiru Labs
713 
714 pragma solidity ^0.8.4;
715 
716 
717 /**
718  * @dev Interface of ERC721ABurnable.
719  */
720 interface IERC721ABurnable is IERC721A {
721     /**
722      * @dev Burns `tokenId`. See {ERC721A-_burn}.
723      *
724      * Requirements:
725      *
726      * - The caller must own `tokenId` or be an approved operator.
727      */
728     function burn(uint256 tokenId) external;
729 }
730 
731 // File: testnet_TOA/talesofaleko/lib/ERC721A/contracts/ERC721A.sol
732 
733 
734 // ERC721A Contracts v4.2.3
735 // Creator: Chiru Labs
736 
737 pragma solidity ^0.8.4;
738 
739 
740 /**
741  * @dev Interface of ERC721 token receiver.
742  */
743 interface ERC721A__IERC721Receiver {
744     function onERC721Received(
745         address operator,
746         address from,
747         uint256 tokenId,
748         bytes calldata data
749     ) external returns (bytes4);
750 }
751 
752 /**
753  * @title ERC721A
754  *
755  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
756  * Non-Fungible Token Standard, including the Metadata extension.
757  * Optimized for lower gas during batch mints.
758  *
759  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
760  * starting from `_startTokenId()`.
761  *
762  * Assumptions:
763  *
764  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
765  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
766  */
767 contract ERC721A is IERC721A {
768     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
769     struct TokenApprovalRef {
770         address value;
771     }
772 
773     // =============================================================
774     //                           CONSTANTS
775     // =============================================================
776 
777     // Mask of an entry in packed address data.
778     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
779 
780     // The bit position of `numberMinted` in packed address data.
781     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
782 
783     // The bit position of `numberBurned` in packed address data.
784     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
785 
786     // The bit position of `aux` in packed address data.
787     uint256 private constant _BITPOS_AUX = 192;
788 
789     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
790     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
791 
792     // The bit position of `startTimestamp` in packed ownership.
793     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
794 
795     // The bit mask of the `burned` bit in packed ownership.
796     uint256 private constant _BITMASK_BURNED = 1 << 224;
797 
798     // The bit position of the `nextInitialized` bit in packed ownership.
799     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
800 
801     // The bit mask of the `nextInitialized` bit in packed ownership.
802     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
803 
804     // The bit position of `extraData` in packed ownership.
805     uint256 private constant _BITPOS_EXTRA_DATA = 232;
806 
807     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
808     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
809 
810     // The mask of the lower 160 bits for addresses.
811     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
812 
813     // The maximum `quantity` that can be minted with {_mintERC2309}.
814     // This limit is to prevent overflows on the address data entries.
815     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
816     // is required to cause an overflow, which is unrealistic.
817     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
818 
819     // The `Transfer` event signature is given by:
820     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
821     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
822         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
823 
824     // =============================================================
825     //                            STORAGE
826     // =============================================================
827 
828     // The next token ID to be minted.
829     uint256 private _currentIndex;
830 
831     // The number of tokens burned.
832     uint256 private _burnCounter;
833 
834     // Token name
835     string private _name;
836 
837     // Token symbol
838     string private _symbol;
839 
840     // Mapping from token ID to ownership details
841     // An empty struct value does not necessarily mean the token is unowned.
842     // See {_packedOwnershipOf} implementation for details.
843     //
844     // Bits Layout:
845     // - [0..159]   `addr`
846     // - [160..223] `startTimestamp`
847     // - [224]      `burned`
848     // - [225]      `nextInitialized`
849     // - [232..255] `extraData`
850     mapping(uint256 => uint256) private _packedOwnerships;
851 
852     // Mapping owner address to address data.
853     //
854     // Bits Layout:
855     // - [0..63]    `balance`
856     // - [64..127]  `numberMinted`
857     // - [128..191] `numberBurned`
858     // - [192..255] `aux`
859     mapping(address => uint256) private _packedAddressData;
860 
861     // Mapping from token ID to approved address.
862     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
863 
864     // Mapping from owner to operator approvals
865     mapping(address => mapping(address => bool)) private _operatorApprovals;
866 
867     // =============================================================
868     //                          CONSTRUCTOR
869     // =============================================================
870 
871     constructor(string memory name_, string memory symbol_) {
872         _name = name_;
873         _symbol = symbol_;
874         _currentIndex = _startTokenId();
875     }
876 
877     // =============================================================
878     //                   TOKEN COUNTING OPERATIONS
879     // =============================================================
880 
881     /**
882      * @dev Returns the starting token ID.
883      * To change the starting token ID, please override this function.
884      */
885     function _startTokenId() internal view virtual returns (uint256) {
886         return 0;
887     }
888 
889     /**
890      * @dev Returns the next token ID to be minted.
891      */
892     function _nextTokenId() internal view virtual returns (uint256) {
893         return _currentIndex;
894     }
895 
896     /**
897      * @dev Returns the total number of tokens in existence.
898      * Burned tokens will reduce the count.
899      * To get the total number of tokens minted, please see {_totalMinted}.
900      */
901     function totalSupply() public view virtual override returns (uint256) {
902         // Counter underflow is impossible as _burnCounter cannot be incremented
903         // more than `_currentIndex - _startTokenId()` times.
904         unchecked {
905             return _currentIndex - _burnCounter - _startTokenId();
906         }
907     }
908 
909     /**
910      * @dev Returns the total amount of tokens minted in the contract.
911      */
912     function _totalMinted() internal view virtual returns (uint256) {
913         // Counter underflow is impossible as `_currentIndex` does not decrement,
914         // and it is initialized to `_startTokenId()`.
915         unchecked {
916             return _currentIndex - _startTokenId();
917         }
918     }
919 
920     /**
921      * @dev Returns the total number of tokens burned.
922      */
923     function _totalBurned() internal view virtual returns (uint256) {
924         return _burnCounter;
925     }
926 
927     // =============================================================
928     //                    ADDRESS DATA OPERATIONS
929     // =============================================================
930 
931     /**
932      * @dev Returns the number of tokens in `owner`'s account.
933      */
934     function balanceOf(address owner) public view virtual override returns (uint256) {
935         if (owner == address(0)) revert BalanceQueryForZeroAddress();
936         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
937     }
938 
939     /**
940      * Returns the number of tokens minted by `owner`.
941      */
942     function _numberMinted(address owner) internal view returns (uint256) {
943         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
944     }
945 
946     /**
947      * Returns the number of tokens burned by or on behalf of `owner`.
948      */
949     function _numberBurned(address owner) internal view returns (uint256) {
950         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
951     }
952 
953     /**
954      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
955      */
956     function _getAux(address owner) internal view returns (uint64) {
957         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
958     }
959 
960     /**
961      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
962      * If there are multiple variables, please pack them into a uint64.
963      */
964     function _setAux(address owner, uint64 aux) internal virtual {
965         uint256 packed = _packedAddressData[owner];
966         uint256 auxCasted;
967         // Cast `aux` with assembly to avoid redundant masking.
968         assembly {
969             auxCasted := aux
970         }
971         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
972         _packedAddressData[owner] = packed;
973     }
974 
975     // =============================================================
976     //                            IERC165
977     // =============================================================
978 
979     /**
980      * @dev Returns true if this contract implements the interface defined by
981      * `interfaceId`. See the corresponding
982      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
983      * to learn more about how these ids are created.
984      *
985      * This function call must use less than 30000 gas.
986      */
987     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
988         // The interface IDs are constants representing the first 4 bytes
989         // of the XOR of all function selectors in the interface.
990         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
991         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
992         return
993             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
994             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
995             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
996     }
997 
998     // =============================================================
999     //                        IERC721Metadata
1000     // =============================================================
1001 
1002     /**
1003      * @dev Returns the token collection name.
1004      */
1005     function name() public view virtual override returns (string memory) {
1006         return _name;
1007     }
1008 
1009     /**
1010      * @dev Returns the token collection symbol.
1011      */
1012     function symbol() public view virtual override returns (string memory) {
1013         return _symbol;
1014     }
1015 
1016     /**
1017      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1018      */
1019     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1020         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1021 
1022         string memory baseURI = _baseURI();
1023         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1024     }
1025 
1026     /**
1027      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1028      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1029      * by default, it can be overridden in child contracts.
1030      */
1031     function _baseURI() internal view virtual returns (string memory) {
1032         return '';
1033     }
1034 
1035     // =============================================================
1036     //                     OWNERSHIPS OPERATIONS
1037     // =============================================================
1038 
1039     /**
1040      * @dev Returns the owner of the `tokenId` token.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must exist.
1045      */
1046     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1047         return address(uint160(_packedOwnershipOf(tokenId)));
1048     }
1049 
1050     /**
1051      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1052      * It gradually moves to O(1) as tokens get transferred around over time.
1053      */
1054     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1055         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1056     }
1057 
1058     /**
1059      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1060      */
1061     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1062         return _unpackedOwnership(_packedOwnerships[index]);
1063     }
1064 
1065     /**
1066      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1067      */
1068     function _initializeOwnershipAt(uint256 index) internal virtual {
1069         if (_packedOwnerships[index] == 0) {
1070             _packedOwnerships[index] = _packedOwnershipOf(index);
1071         }
1072     }
1073 
1074     /**
1075      * Returns the packed ownership data of `tokenId`.
1076      */
1077     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1078         uint256 curr = tokenId;
1079 
1080         unchecked {
1081             if (_startTokenId() <= curr)
1082                 if (curr < _currentIndex) {
1083                     uint256 packed = _packedOwnerships[curr];
1084                     // If not burned.
1085                     if (packed & _BITMASK_BURNED == 0) {
1086                         // Invariant:
1087                         // There will always be an initialized ownership slot
1088                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1089                         // before an unintialized ownership slot
1090                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1091                         // Hence, `curr` will not underflow.
1092                         //
1093                         // We can directly compare the packed value.
1094                         // If the address is zero, packed will be zero.
1095                         while (packed == 0) {
1096                             packed = _packedOwnerships[--curr];
1097                         }
1098                         return packed;
1099                     }
1100                 }
1101         }
1102         revert OwnerQueryForNonexistentToken();
1103     }
1104 
1105     /**
1106      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1107      */
1108     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1109         ownership.addr = address(uint160(packed));
1110         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1111         ownership.burned = packed & _BITMASK_BURNED != 0;
1112         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1113     }
1114 
1115     /**
1116      * @dev Packs ownership data into a single uint256.
1117      */
1118     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1119         assembly {
1120             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1121             owner := and(owner, _BITMASK_ADDRESS)
1122             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1123             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1124         }
1125     }
1126 
1127     /**
1128      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1129      */
1130     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1131         // For branchless setting of the `nextInitialized` flag.
1132         assembly {
1133             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1134             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1135         }
1136     }
1137 
1138     // =============================================================
1139     //                      APPROVAL OPERATIONS
1140     // =============================================================
1141 
1142     /**
1143      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1144      * The approval is cleared when the token is transferred.
1145      *
1146      * Only a single account can be approved at a time, so approving the
1147      * zero address clears previous approvals.
1148      *
1149      * Requirements:
1150      *
1151      * - The caller must own the token or be an approved operator.
1152      * - `tokenId` must exist.
1153      *
1154      * Emits an {Approval} event.
1155      */
1156     function approve(address to, uint256 tokenId) public payable virtual override {
1157         address owner = ownerOf(tokenId);
1158 
1159         if (_msgSenderERC721A() != owner)
1160             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1161                 revert ApprovalCallerNotOwnerNorApproved();
1162             }
1163 
1164         _tokenApprovals[tokenId].value = to;
1165         emit Approval(owner, to, tokenId);
1166     }
1167 
1168     /**
1169      * @dev Returns the account approved for `tokenId` token.
1170      *
1171      * Requirements:
1172      *
1173      * - `tokenId` must exist.
1174      */
1175     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1176         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1177 
1178         return _tokenApprovals[tokenId].value;
1179     }
1180 
1181     /**
1182      * @dev Approve or remove `operator` as an operator for the caller.
1183      * Operators can call {transferFrom} or {safeTransferFrom}
1184      * for any token owned by the caller.
1185      *
1186      * Requirements:
1187      *
1188      * - The `operator` cannot be the caller.
1189      *
1190      * Emits an {ApprovalForAll} event.
1191      */
1192     function setApprovalForAll(address operator, bool approved) public virtual override {
1193         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1194         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1195     }
1196 
1197     /**
1198      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1199      *
1200      * See {setApprovalForAll}.
1201      */
1202     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1203         return _operatorApprovals[owner][operator];
1204     }
1205 
1206     /**
1207      * @dev Returns whether `tokenId` exists.
1208      *
1209      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1210      *
1211      * Tokens start existing when they are minted. See {_mint}.
1212      */
1213     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1214         return
1215             _startTokenId() <= tokenId &&
1216             tokenId < _currentIndex && // If within bounds,
1217             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1218     }
1219 
1220     /**
1221      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1222      */
1223     function _isSenderApprovedOrOwner(
1224         address approvedAddress,
1225         address owner,
1226         address msgSender
1227     ) private pure returns (bool result) {
1228         assembly {
1229             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1230             owner := and(owner, _BITMASK_ADDRESS)
1231             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1232             msgSender := and(msgSender, _BITMASK_ADDRESS)
1233             // `msgSender == owner || msgSender == approvedAddress`.
1234             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1235         }
1236     }
1237 
1238     /**
1239      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1240      */
1241     function _getApprovedSlotAndAddress(uint256 tokenId)
1242         private
1243         view
1244         returns (uint256 approvedAddressSlot, address approvedAddress)
1245     {
1246         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1247         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1248         assembly {
1249             approvedAddressSlot := tokenApproval.slot
1250             approvedAddress := sload(approvedAddressSlot)
1251         }
1252     }
1253 
1254     // =============================================================
1255     //                      TRANSFER OPERATIONS
1256     // =============================================================
1257 
1258     /**
1259      * @dev Transfers `tokenId` from `from` to `to`.
1260      *
1261      * Requirements:
1262      *
1263      * - `from` cannot be the zero address.
1264      * - `to` cannot be the zero address.
1265      * - `tokenId` token must be owned by `from`.
1266      * - If the caller is not `from`, it must be approved to move this token
1267      * by either {approve} or {setApprovalForAll}.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function transferFrom(
1272         address from,
1273         address to,
1274         uint256 tokenId
1275     ) public payable virtual override {
1276         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1277 
1278         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1279 
1280         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1281 
1282         // The nested ifs save around 20+ gas over a compound boolean condition.
1283         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1284             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1285 
1286         if (to == address(0)) revert TransferToZeroAddress();
1287 
1288         _beforeTokenTransfers(from, to, tokenId, 1);
1289 
1290         // Clear approvals from the previous owner.
1291         assembly {
1292             if approvedAddress {
1293                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1294                 sstore(approvedAddressSlot, 0)
1295             }
1296         }
1297 
1298         // Underflow of the sender's balance is impossible because we check for
1299         // ownership above and the recipient's balance can't realistically overflow.
1300         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1301         unchecked {
1302             // We can directly increment and decrement the balances.
1303             --_packedAddressData[from]; // Updates: `balance -= 1`.
1304             ++_packedAddressData[to]; // Updates: `balance += 1`.
1305 
1306             // Updates:
1307             // - `address` to the next owner.
1308             // - `startTimestamp` to the timestamp of transfering.
1309             // - `burned` to `false`.
1310             // - `nextInitialized` to `true`.
1311             _packedOwnerships[tokenId] = _packOwnershipData(
1312                 to,
1313                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1314             );
1315 
1316             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1317             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1318                 uint256 nextTokenId = tokenId + 1;
1319                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1320                 if (_packedOwnerships[nextTokenId] == 0) {
1321                     // If the next slot is within bounds.
1322                     if (nextTokenId != _currentIndex) {
1323                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1324                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1325                     }
1326                 }
1327             }
1328         }
1329 
1330         emit Transfer(from, to, tokenId);
1331         _afterTokenTransfers(from, to, tokenId, 1);
1332     }
1333 
1334     /**
1335      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1336      */
1337     function safeTransferFrom(
1338         address from,
1339         address to,
1340         uint256 tokenId
1341     ) public payable virtual override {
1342         safeTransferFrom(from, to, tokenId, '');
1343     }
1344 
1345     /**
1346      * @dev Safely transfers `tokenId` token from `from` to `to`.
1347      *
1348      * Requirements:
1349      *
1350      * - `from` cannot be the zero address.
1351      * - `to` cannot be the zero address.
1352      * - `tokenId` token must exist and be owned by `from`.
1353      * - If the caller is not `from`, it must be approved to move this token
1354      * by either {approve} or {setApprovalForAll}.
1355      * - If `to` refers to a smart contract, it must implement
1356      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1357      *
1358      * Emits a {Transfer} event.
1359      */
1360     function safeTransferFrom(
1361         address from,
1362         address to,
1363         uint256 tokenId,
1364         bytes memory _data
1365     ) public payable virtual override {
1366         transferFrom(from, to, tokenId);
1367         if (to.code.length != 0)
1368             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1369                 revert TransferToNonERC721ReceiverImplementer();
1370             }
1371     }
1372 
1373     /**
1374      * @dev Hook that is called before a set of serially-ordered token IDs
1375      * are about to be transferred. This includes minting.
1376      * And also called before burning one token.
1377      *
1378      * `startTokenId` - the first token ID to be transferred.
1379      * `quantity` - the amount to be transferred.
1380      *
1381      * Calling conditions:
1382      *
1383      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1384      * transferred to `to`.
1385      * - When `from` is zero, `tokenId` will be minted for `to`.
1386      * - When `to` is zero, `tokenId` will be burned by `from`.
1387      * - `from` and `to` are never both zero.
1388      */
1389     function _beforeTokenTransfers(
1390         address from,
1391         address to,
1392         uint256 startTokenId,
1393         uint256 quantity
1394     ) internal virtual {}
1395 
1396     /**
1397      * @dev Hook that is called after a set of serially-ordered token IDs
1398      * have been transferred. This includes minting.
1399      * And also called after one token has been burned.
1400      *
1401      * `startTokenId` - the first token ID to be transferred.
1402      * `quantity` - the amount to be transferred.
1403      *
1404      * Calling conditions:
1405      *
1406      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1407      * transferred to `to`.
1408      * - When `from` is zero, `tokenId` has been minted for `to`.
1409      * - When `to` is zero, `tokenId` has been burned by `from`.
1410      * - `from` and `to` are never both zero.
1411      */
1412     function _afterTokenTransfers(
1413         address from,
1414         address to,
1415         uint256 startTokenId,
1416         uint256 quantity
1417     ) internal virtual {}
1418 
1419     /**
1420      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1421      *
1422      * `from` - Previous owner of the given token ID.
1423      * `to` - Target address that will receive the token.
1424      * `tokenId` - Token ID to be transferred.
1425      * `_data` - Optional data to send along with the call.
1426      *
1427      * Returns whether the call correctly returned the expected magic value.
1428      */
1429     function _checkContractOnERC721Received(
1430         address from,
1431         address to,
1432         uint256 tokenId,
1433         bytes memory _data
1434     ) private returns (bool) {
1435         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1436             bytes4 retval
1437         ) {
1438             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1439         } catch (bytes memory reason) {
1440             if (reason.length == 0) {
1441                 revert TransferToNonERC721ReceiverImplementer();
1442             } else {
1443                 assembly {
1444                     revert(add(32, reason), mload(reason))
1445                 }
1446             }
1447         }
1448     }
1449 
1450     // =============================================================
1451     //                        MINT OPERATIONS
1452     // =============================================================
1453 
1454     /**
1455      * @dev Mints `quantity` tokens and transfers them to `to`.
1456      *
1457      * Requirements:
1458      *
1459      * - `to` cannot be the zero address.
1460      * - `quantity` must be greater than 0.
1461      *
1462      * Emits a {Transfer} event for each mint.
1463      */
1464     function _mint(address to, uint256 quantity) internal virtual {
1465         uint256 startTokenId = _currentIndex;
1466         if (quantity == 0) revert MintZeroQuantity();
1467 
1468         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1469 
1470         // Overflows are incredibly unrealistic.
1471         // `balance` and `numberMinted` have a maximum limit of 2**64.
1472         // `tokenId` has a maximum limit of 2**256.
1473         unchecked {
1474             // Updates:
1475             // - `balance += quantity`.
1476             // - `numberMinted += quantity`.
1477             //
1478             // We can directly add to the `balance` and `numberMinted`.
1479             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1480 
1481             // Updates:
1482             // - `address` to the owner.
1483             // - `startTimestamp` to the timestamp of minting.
1484             // - `burned` to `false`.
1485             // - `nextInitialized` to `quantity == 1`.
1486             _packedOwnerships[startTokenId] = _packOwnershipData(
1487                 to,
1488                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1489             );
1490 
1491             uint256 toMasked;
1492             uint256 end = startTokenId + quantity;
1493 
1494             // Use assembly to loop and emit the `Transfer` event for gas savings.
1495             // The duplicated `log4` removes an extra check and reduces stack juggling.
1496             // The assembly, together with the surrounding Solidity code, have been
1497             // delicately arranged to nudge the compiler into producing optimized opcodes.
1498             assembly {
1499                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1500                 toMasked := and(to, _BITMASK_ADDRESS)
1501                 // Emit the `Transfer` event.
1502                 log4(
1503                     0, // Start of data (0, since no data).
1504                     0, // End of data (0, since no data).
1505                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1506                     0, // `address(0)`.
1507                     toMasked, // `to`.
1508                     startTokenId // `tokenId`.
1509                 )
1510 
1511                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1512                 // that overflows uint256 will make the loop run out of gas.
1513                 // The compiler will optimize the `iszero` away for performance.
1514                 for {
1515                     let tokenId := add(startTokenId, 1)
1516                 } iszero(eq(tokenId, end)) {
1517                     tokenId := add(tokenId, 1)
1518                 } {
1519                     // Emit the `Transfer` event. Similar to above.
1520                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1521                 }
1522             }
1523             if (toMasked == 0) revert MintToZeroAddress();
1524 
1525             _currentIndex = end;
1526         }
1527         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1528     }
1529 
1530     /**
1531      * @dev Mints `quantity` tokens and transfers them to `to`.
1532      *
1533      * This function is intended for efficient minting only during contract creation.
1534      *
1535      * It emits only one {ConsecutiveTransfer} as defined in
1536      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1537      * instead of a sequence of {Transfer} event(s).
1538      *
1539      * Calling this function outside of contract creation WILL make your contract
1540      * non-compliant with the ERC721 standard.
1541      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1542      * {ConsecutiveTransfer} event is only permissible during contract creation.
1543      *
1544      * Requirements:
1545      *
1546      * - `to` cannot be the zero address.
1547      * - `quantity` must be greater than 0.
1548      *
1549      * Emits a {ConsecutiveTransfer} event.
1550      */
1551     function _mintERC2309(address to, uint256 quantity) internal virtual {
1552         uint256 startTokenId = _currentIndex;
1553         if (to == address(0)) revert MintToZeroAddress();
1554         if (quantity == 0) revert MintZeroQuantity();
1555         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1556 
1557         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1558 
1559         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1560         unchecked {
1561             // Updates:
1562             // - `balance += quantity`.
1563             // - `numberMinted += quantity`.
1564             //
1565             // We can directly add to the `balance` and `numberMinted`.
1566             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1567 
1568             // Updates:
1569             // - `address` to the owner.
1570             // - `startTimestamp` to the timestamp of minting.
1571             // - `burned` to `false`.
1572             // - `nextInitialized` to `quantity == 1`.
1573             _packedOwnerships[startTokenId] = _packOwnershipData(
1574                 to,
1575                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1576             );
1577 
1578             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1579 
1580             _currentIndex = startTokenId + quantity;
1581         }
1582         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1583     }
1584 
1585     /**
1586      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1587      *
1588      * Requirements:
1589      *
1590      * - If `to` refers to a smart contract, it must implement
1591      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1592      * - `quantity` must be greater than 0.
1593      *
1594      * See {_mint}.
1595      *
1596      * Emits a {Transfer} event for each mint.
1597      */
1598     function _safeMint(
1599         address to,
1600         uint256 quantity,
1601         bytes memory _data
1602     ) internal virtual {
1603         _mint(to, quantity);
1604 
1605         unchecked {
1606             if (to.code.length != 0) {
1607                 uint256 end = _currentIndex;
1608                 uint256 index = end - quantity;
1609                 do {
1610                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1611                         revert TransferToNonERC721ReceiverImplementer();
1612                     }
1613                 } while (index < end);
1614                 // Reentrancy protection.
1615                 if (_currentIndex != end) revert();
1616             }
1617         }
1618     }
1619 
1620     /**
1621      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1622      */
1623     function _safeMint(address to, uint256 quantity) internal virtual {
1624         _safeMint(to, quantity, '');
1625     }
1626 
1627     // =============================================================
1628     //                        BURN OPERATIONS
1629     // =============================================================
1630 
1631     /**
1632      * @dev Equivalent to `_burn(tokenId, false)`.
1633      */
1634     function _burn(uint256 tokenId) internal virtual {
1635         _burn(tokenId, false);
1636     }
1637 
1638     /**
1639      * @dev Destroys `tokenId`.
1640      * The approval is cleared when the token is burned.
1641      *
1642      * Requirements:
1643      *
1644      * - `tokenId` must exist.
1645      *
1646      * Emits a {Transfer} event.
1647      */
1648     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1649         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1650 
1651         address from = address(uint160(prevOwnershipPacked));
1652 
1653         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1654 
1655         if (approvalCheck) {
1656             // The nested ifs save around 20+ gas over a compound boolean condition.
1657             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1658                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1659         }
1660 
1661         _beforeTokenTransfers(from, address(0), tokenId, 1);
1662 
1663         // Clear approvals from the previous owner.
1664         assembly {
1665             if approvedAddress {
1666                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1667                 sstore(approvedAddressSlot, 0)
1668             }
1669         }
1670 
1671         // Underflow of the sender's balance is impossible because we check for
1672         // ownership above and the recipient's balance can't realistically overflow.
1673         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1674         unchecked {
1675             // Updates:
1676             // - `balance -= 1`.
1677             // - `numberBurned += 1`.
1678             //
1679             // We can directly decrement the balance, and increment the number burned.
1680             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1681             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1682 
1683             // Updates:
1684             // - `address` to the last owner.
1685             // - `startTimestamp` to the timestamp of burning.
1686             // - `burned` to `true`.
1687             // - `nextInitialized` to `true`.
1688             _packedOwnerships[tokenId] = _packOwnershipData(
1689                 from,
1690                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1691             );
1692 
1693             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1694             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1695                 uint256 nextTokenId = tokenId + 1;
1696                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1697                 if (_packedOwnerships[nextTokenId] == 0) {
1698                     // If the next slot is within bounds.
1699                     if (nextTokenId != _currentIndex) {
1700                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1701                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1702                     }
1703                 }
1704             }
1705         }
1706 
1707         emit Transfer(from, address(0), tokenId);
1708         _afterTokenTransfers(from, address(0), tokenId, 1);
1709 
1710         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1711         unchecked {
1712             _burnCounter++;
1713         }
1714     }
1715 
1716     // =============================================================
1717     //                     EXTRA DATA OPERATIONS
1718     // =============================================================
1719 
1720     /**
1721      * @dev Directly sets the extra data for the ownership data `index`.
1722      */
1723     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1724         uint256 packed = _packedOwnerships[index];
1725         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1726         uint256 extraDataCasted;
1727         // Cast `extraData` with assembly to avoid redundant masking.
1728         assembly {
1729             extraDataCasted := extraData
1730         }
1731         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1732         _packedOwnerships[index] = packed;
1733     }
1734 
1735     /**
1736      * @dev Called during each token transfer to set the 24bit `extraData` field.
1737      * Intended to be overridden by the cosumer contract.
1738      *
1739      * `previousExtraData` - the value of `extraData` before transfer.
1740      *
1741      * Calling conditions:
1742      *
1743      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1744      * transferred to `to`.
1745      * - When `from` is zero, `tokenId` will be minted for `to`.
1746      * - When `to` is zero, `tokenId` will be burned by `from`.
1747      * - `from` and `to` are never both zero.
1748      */
1749     function _extraData(
1750         address from,
1751         address to,
1752         uint24 previousExtraData
1753     ) internal view virtual returns (uint24) {}
1754 
1755     /**
1756      * @dev Returns the next extra data for the packed ownership data.
1757      * The returned result is shifted into position.
1758      */
1759     function _nextExtraData(
1760         address from,
1761         address to,
1762         uint256 prevOwnershipPacked
1763     ) private view returns (uint256) {
1764         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1765         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1766     }
1767 
1768     // =============================================================
1769     //                       OTHER OPERATIONS
1770     // =============================================================
1771 
1772     /**
1773      * @dev Returns the message sender (defaults to `msg.sender`).
1774      *
1775      * If you are writing GSN compatible contracts, you need to override this function.
1776      */
1777     function _msgSenderERC721A() internal view virtual returns (address) {
1778         return msg.sender;
1779     }
1780 
1781     /**
1782      * @dev Converts a uint256 to its ASCII string decimal representation.
1783      */
1784     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1785         assembly {
1786             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1787             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1788             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1789             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1790             let m := add(mload(0x40), 0xa0)
1791             // Update the free memory pointer to allocate.
1792             mstore(0x40, m)
1793             // Assign the `str` to the end.
1794             str := sub(m, 0x20)
1795             // Zeroize the slot after the string.
1796             mstore(str, 0)
1797 
1798             // Cache the end of the memory to calculate the length later.
1799             let end := str
1800 
1801             // We write the string from rightmost digit to leftmost digit.
1802             // The following is essentially a do-while loop that also handles the zero case.
1803             // prettier-ignore
1804             for { let temp := value } 1 {} {
1805                 str := sub(str, 1)
1806                 // Write the character to the pointer.
1807                 // The ASCII index of the '0' character is 48.
1808                 mstore8(str, add(48, mod(temp, 10)))
1809                 // Keep dividing `temp` until zero.
1810                 temp := div(temp, 10)
1811                 // prettier-ignore
1812                 if iszero(temp) { break }
1813             }
1814 
1815             let length := sub(end, str)
1816             // Move the pointer 32 bytes leftwards to make room for the length.
1817             str := sub(str, 0x20)
1818             // Store the length.
1819             mstore(str, length)
1820         }
1821     }
1822 }
1823 
1824 // File: testnet_TOA/talesofaleko/lib/ERC721A/contracts/extensions/ERC721ABurnable.sol
1825 
1826 
1827 // ERC721A Contracts v4.2.3
1828 // Creator: Chiru Labs
1829 
1830 pragma solidity ^0.8.4;
1831 
1832 
1833 
1834 /**
1835  * @title ERC721ABurnable.
1836  *
1837  * @dev ERC721A token that can be irreversibly burned (destroyed).
1838  */
1839 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1840     /**
1841      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1842      *
1843      * Requirements:
1844      *
1845      * - The caller must own `tokenId` or be an approved operator.
1846      */
1847     function burn(uint256 tokenId) public virtual override {
1848         _burn(tokenId, true);
1849     }
1850 }
1851 
1852 // File: testnet_TOA/talesofaleko/src/TOAcontract.sol
1853 
1854 
1855 pragma solidity ^0.8.0;
1856 
1857 
1858 
1859 
1860 
1861 
1862 
1863 /**
1864 
1865     Tales Of Aleko contract
1866 
1867  */
1868 
1869 error SaleClosed();
1870 error WhitelistSaleSoldOut();
1871 error OGSaleSoldOut();
1872 error PublicSaleSoldOut();
1873 error ExceedsWLUserAllowance();
1874 error ExceedsOGUserAllowance();
1875 error ExceedsPubUserAllowance();
1876 error InsufficientEth();
1877 error InvalidWallet();
1878 error AmountError();
1879 error OutOfStock();
1880 error ExceedsMaxSupply();
1881 error ExceedsAllocationMax();
1882 error NoBalance();
1883 error ProvenanceLocked();
1884 error WhitelistSaleClosed();
1885 error PublicSaleClosed();
1886 error OGSaleClosed();
1887 error ReallocationError();
1888 
1889 
1890 contract TOAcontract is 
1891     ERC721A,
1892     ReentrancyGuard,
1893     Ownable{
1894 
1895         uint256 public constant TOA_MAX_SUPPLY = 1000;
1896         
1897         uint256 public TOA_TEAM_ALLOCATION = 50;
1898         uint256 public TOA_MINT_ALLOCATION = 1;
1899 
1900         address private _ownerAddress;
1901 
1902         uint64 public ogAmountMinted;
1903         uint64 public wlAmountMinted;
1904 
1905         bool public saleIsLive = false;
1906         bool public wlLive = false;
1907         bool public ogLive = false;
1908 
1909         bytes32 public wl_root = 0xc12e87a3387c3a490e80be2905b2a54e6f720ea93a8cc5e0b7a11fb13938286a;
1910         bytes32 public og_root = 0x07dfbf5e6542ddc13a22e8874f2b419b4c22f18846b227f9d39519bea1fa85b9;
1911 
1912         uint64 public teamAmountMinted;
1913 
1914 
1915         // Metadata URI
1916         string public baseTokenURI = "https://talesofaleko.infura-ipfs.io/ipfs/QmPHaDjdBxYq1gZbMmPd5BR1Ax2N46YVt2ju4AtEMkgCju/";
1917 
1918     constructor()
1919         ERC721A("Tales Of Aleko","TOA")
1920         ReentrancyGuard(){
1921             _ownerAddress = msg.sender;
1922         }
1923 
1924     // -------
1925     // Owner Functions
1926     // -------
1927     modifier callerIsUser {
1928         require(tx.origin == msg.sender, "The caller is another contract");
1929         _;
1930     }
1931 
1932     modifier liveSale {
1933         if(!saleIsLive) revert SaleClosed();
1934         _;
1935     }
1936 
1937     function setRootWl(bytes32 _wl_root) public onlyOwner {
1938         wl_root = _wl_root;
1939     }
1940 
1941     function setRootOg(bytes32 _og_root) public onlyOwner {
1942         og_root = _og_root;
1943     }
1944 
1945     function setBaseURI(string calldata _baseTokenURI) public onlyOwner {
1946         baseTokenURI = _baseTokenURI;
1947     }
1948 
1949     function _baseURI() internal view virtual override returns (string memory) {
1950         return baseTokenURI;
1951     }
1952 
1953     function teamMint(address user, uint64 tokenQuantity) external onlyOwner {
1954         if(_totalMinted() + tokenQuantity > TOA_MAX_SUPPLY) revert ExceedsMaxSupply();
1955         if(teamAmountMinted + tokenQuantity > TOA_TEAM_ALLOCATION) revert ExceedsAllocationMax(); 
1956 
1957         _safeMint(user, tokenQuantity);        
1958         teamAmountMinted += tokenQuantity;
1959     }
1960 
1961     function ogMint(bytes32[] calldata merkleProof) external payable 
1962     liveSale callerIsUser{
1963         
1964         
1965         if(!ogLive) revert OGSaleClosed();
1966         //Check if the wallet is OG
1967         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1968         require(MerkleProof.verify(merkleProof, og_root, leaf),"Invalid Wallet");
1969         uint64 mintedCount = _getAux(msg.sender);
1970         require(mintedCount + 1 <= TOA_MINT_ALLOCATION,"Exceeds WLUser Allowance");
1971         require(_totalMinted()+1 <= TOA_MAX_SUPPLY,"Exceeds Max Supply");
1972         _safeMint(msg.sender, 1);
1973         _setAux(msg.sender, mintedCount+1);
1974 
1975     }
1976 
1977     function whitelistMint(bytes32[] calldata merkleProof) external payable 
1978     liveSale callerIsUser{
1979         
1980         //Check WL is live
1981         if(!wlLive) revert WhitelistSaleClosed();
1982 
1983         //check if wallet is WL
1984         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1985         require(MerkleProof.verify(merkleProof, wl_root, leaf),"Invalid Wallet");
1986 
1987         uint64 mintedCount = _getAux(msg.sender);
1988         require(mintedCount + 1 <= TOA_MINT_ALLOCATION,"Exceeds WLUser Allowance");
1989         require(_totalMinted()+1 <= TOA_MAX_SUPPLY,"Exceeds Max Supply");
1990         _safeMint(msg.sender, 1);
1991         _setAux(msg.sender, mintedCount+1);
1992 
1993     }
1994 
1995 
1996     function changeSaleStatus() external onlyOwner {
1997         saleIsLive = !saleIsLive;
1998     }
1999 
2000     function changeWhitelistStatus() external onlyOwner {
2001         wlLive = !wlLive;
2002     }
2003 
2004     function changeOGSaleStatus() external onlyOwner {
2005         ogLive = !ogLive;
2006     }
2007 
2008     function _startTokenId() internal view virtual override returns (uint256) {
2009         return 1;
2010     }
2011 
2012     function setTeamLimit(uint256 _limit) external onlyOwner {
2013         TOA_TEAM_ALLOCATION = _limit;
2014     }
2015 
2016     function setAllocLimit(uint256 _limit) external onlyOwner {
2017         TOA_MINT_ALLOCATION = _limit;
2018     }
2019 
2020     function withdraw() public onlyOwner {
2021         uint256 balance = address(this).balance;
2022         payable(_msgSender()).transfer(balance);
2023     }
2024 
2025     function saleStatus()
2026         public
2027         view
2028         virtual
2029         returns (bool)
2030     {
2031         return saleIsLive;
2032     }
2033 
2034     function ogSaleStatus()
2035         public
2036         view
2037         virtual
2038         returns (bool)
2039     {
2040         return ogLive;
2041     }
2042 
2043     function wlSaleStatus()
2044         public
2045         view
2046         virtual
2047         returns (bool)
2048     {
2049         return wlLive;
2050     }
2051 
2052 
2053     function burn(uint256 tokenId) public
2054     callerIsUser{
2055             require(ownerOf(tokenId)==msg.sender,"You're not the owner of this NFT");
2056             _burn(tokenId);
2057     }
2058 
2059 
2060 }