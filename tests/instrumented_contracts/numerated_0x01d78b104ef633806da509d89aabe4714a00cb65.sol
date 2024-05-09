1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Tree proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  *
18  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
19  * hashing, or use a hash function other than keccak256 for hashing leaves.
20  * This is because the concatenation of a sorted pair of internal nodes in
21  * the merkle tree could be reinterpreted as a leaf value.
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
59     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
60         bytes32 computedHash = leaf;
61         for (uint256 i = 0; i < proof.length; i++) {
62             computedHash = _hashPair(computedHash, proof[i]);
63         }
64         return computedHash;
65     }
66 
67     /**
68      * @dev Calldata version of {processProof}
69      *
70      * _Available since v4.7._
71      */
72     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
73         bytes32 computedHash = leaf;
74         for (uint256 i = 0; i < proof.length; i++) {
75             computedHash = _hashPair(computedHash, proof[i]);
76         }
77         return computedHash;
78     }
79 
80     /**
81      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
82      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
83      *
84      * _Available since v4.7._
85      */
86     function multiProofVerify(
87         bytes32[] memory proof,
88         bool[] memory proofFlags,
89         bytes32 root,
90         bytes32[] memory leaves
91     ) internal pure returns (bool) {
92         return processMultiProof(proof, proofFlags, leaves) == root;
93     }
94 
95     /**
96      * @dev Calldata version of {multiProofVerify}
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
110      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
111      * consuming from one or the other at each step according to the instructions given by
112      * `proofFlags`.
113      *
114      * _Available since v4.7._
115      */
116     function processMultiProof(
117         bytes32[] memory proof,
118         bool[] memory proofFlags,
119         bytes32[] memory leaves
120     ) internal pure returns (bytes32 merkleRoot) {
121         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
122         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
123         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
124         // the merkle tree.
125         uint256 leavesLen = leaves.length;
126         uint256 totalHashes = proofFlags.length;
127 
128         // Check proof validity.
129         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
130 
131         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
132         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
133         bytes32[] memory hashes = new bytes32[](totalHashes);
134         uint256 leafPos = 0;
135         uint256 hashPos = 0;
136         uint256 proofPos = 0;
137         // At each step, we compute the next hash using two values:
138         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
139         //   get the next hash.
140         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
141         //   `proof` array.
142         for (uint256 i = 0; i < totalHashes; i++) {
143             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
144             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
145             hashes[i] = _hashPair(a, b);
146         }
147 
148         if (totalHashes > 0) {
149             return hashes[totalHashes - 1];
150         } else if (leavesLen > 0) {
151             return leaves[0];
152         } else {
153             return proof[0];
154         }
155     }
156 
157     /**
158      * @dev Calldata version of {processMultiProof}
159      *
160      * _Available since v4.7._
161      */
162     function processMultiProofCalldata(
163         bytes32[] calldata proof,
164         bool[] calldata proofFlags,
165         bytes32[] memory leaves
166     ) internal pure returns (bytes32 merkleRoot) {
167         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
168         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
169         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
170         // the merkle tree.
171         uint256 leavesLen = leaves.length;
172         uint256 totalHashes = proofFlags.length;
173 
174         // Check proof validity.
175         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
176 
177         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
178         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
179         bytes32[] memory hashes = new bytes32[](totalHashes);
180         uint256 leafPos = 0;
181         uint256 hashPos = 0;
182         uint256 proofPos = 0;
183         // At each step, we compute the next hash using two values:
184         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
185         //   get the next hash.
186         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
187         //   `proof` array.
188         for (uint256 i = 0; i < totalHashes; i++) {
189             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
190             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
191             hashes[i] = _hashPair(a, b);
192         }
193 
194         if (totalHashes > 0) {
195             return hashes[totalHashes - 1];
196         } else if (leavesLen > 0) {
197             return leaves[0];
198         } else {
199             return proof[0];
200         }
201     }
202 
203     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
204         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
205     }
206 
207     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
208         /// @solidity memory-safe-assembly
209         assembly {
210             mstore(0x00, a)
211             mstore(0x20, b)
212             value := keccak256(0x00, 0x40)
213         }
214     }
215 }
216 
217 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
218 
219 
220 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev Contract module that helps prevent reentrant calls to a function.
226  *
227  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
228  * available, which can be applied to functions to make sure there are no nested
229  * (reentrant) calls to them.
230  *
231  * Note that because there is a single `nonReentrant` guard, functions marked as
232  * `nonReentrant` may not call one another. This can be worked around by making
233  * those functions `private`, and then adding `external` `nonReentrant` entry
234  * points to them.
235  *
236  * TIP: If you would like to learn more about reentrancy and alternative ways
237  * to protect against it, check out our blog post
238  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
239  */
240 abstract contract ReentrancyGuard {
241     // Booleans are more expensive than uint256 or any type that takes up a full
242     // word because each write operation emits an extra SLOAD to first read the
243     // slot's contents, replace the bits taken up by the boolean, and then write
244     // back. This is the compiler's defense against contract upgrades and
245     // pointer aliasing, and it cannot be disabled.
246 
247     // The values being non-zero value makes deployment a bit more expensive,
248     // but in exchange the refund on every call to nonReentrant will be lower in
249     // amount. Since refunds are capped to a percentage of the total
250     // transaction's gas, it is best to keep them low in cases like this one, to
251     // increase the likelihood of the full refund coming into effect.
252     uint256 private constant _NOT_ENTERED = 1;
253     uint256 private constant _ENTERED = 2;
254 
255     uint256 private _status;
256 
257     constructor() {
258         _status = _NOT_ENTERED;
259     }
260 
261     /**
262      * @dev Prevents a contract from calling itself, directly or indirectly.
263      * Calling a `nonReentrant` function from another `nonReentrant`
264      * function is not supported. It is possible to prevent this from happening
265      * by making the `nonReentrant` function external, and making it call a
266      * `private` function that does the actual work.
267      */
268     modifier nonReentrant() {
269         // On the first call to nonReentrant, _notEntered will be true
270         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
271 
272         // Any calls to nonReentrant after this point will fail
273         _status = _ENTERED;
274 
275         _;
276 
277         // By storing the original value once again, a refund is triggered (see
278         // https://eips.ethereum.org/EIPS/eip-2200)
279         _status = _NOT_ENTERED;
280     }
281 }
282 
283 // File: @openzeppelin/contracts/utils/Context.sol
284 
285 
286 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev Provides information about the current execution context, including the
292  * sender of the transaction and its data. While these are generally available
293  * via msg.sender and msg.data, they should not be accessed in such a direct
294  * manner, since when dealing with meta-transactions the account sending and
295  * paying for execution may not be the actual sender (as far as an application
296  * is concerned).
297  *
298  * This contract is only required for intermediate, library-like contracts.
299  */
300 abstract contract Context {
301     function _msgSender() internal view virtual returns (address) {
302         return msg.sender;
303     }
304 
305     function _msgData() internal view virtual returns (bytes calldata) {
306         return msg.data;
307     }
308 }
309 
310 // File: @openzeppelin/contracts/access/Ownable.sol
311 
312 
313 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 
318 /**
319  * @dev Contract module which provides a basic access control mechanism, where
320  * there is an account (an owner) that can be granted exclusive access to
321  * specific functions.
322  *
323  * By default, the owner account will be the one that deploys the contract. This
324  * can later be changed with {transferOwnership}.
325  *
326  * This module is used through inheritance. It will make available the modifier
327  * `onlyOwner`, which can be applied to your functions to restrict their use to
328  * the owner.
329  */
330 abstract contract Ownable is Context {
331     address private _owner;
332 
333     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
334 
335     /**
336      * @dev Initializes the contract setting the deployer as the initial owner.
337      */
338     constructor() {
339         _transferOwnership(_msgSender());
340     }
341 
342     /**
343      * @dev Throws if called by any account other than the owner.
344      */
345     modifier onlyOwner() {
346         _checkOwner();
347         _;
348     }
349 
350     /**
351      * @dev Returns the address of the current owner.
352      */
353     function owner() public view virtual returns (address) {
354         return _owner;
355     }
356 
357     /**
358      * @dev Throws if the sender is not the owner.
359      */
360     function _checkOwner() internal view virtual {
361         require(owner() == _msgSender(), "Ownable: caller is not the owner");
362     }
363 
364     /**
365      * @dev Leaves the contract without owner. It will not be possible to call
366      * `onlyOwner` functions anymore. Can only be called by the current owner.
367      *
368      * NOTE: Renouncing ownership will leave the contract without an owner,
369      * thereby removing any functionality that is only available to the owner.
370      */
371     function renounceOwnership() public virtual onlyOwner {
372         _transferOwnership(address(0));
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Can only be called by the current owner.
378      */
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(newOwner != address(0), "Ownable: new owner is the zero address");
381         _transferOwnership(newOwner);
382     }
383 
384     /**
385      * @dev Transfers ownership of the contract to a new account (`newOwner`).
386      * Internal function without access restriction.
387      */
388     function _transferOwnership(address newOwner) internal virtual {
389         address oldOwner = _owner;
390         _owner = newOwner;
391         emit OwnershipTransferred(oldOwner, newOwner);
392     }
393 }
394 
395 // File: erc721a/contracts/IERC721A.sol
396 
397 
398 // ERC721A Contracts v4.2.3
399 // Creator: Chiru Labs
400 
401 pragma solidity ^0.8.4;
402 
403 /**
404  * @dev Interface of ERC721A.
405  */
406 interface IERC721A {
407     /**
408      * The caller must own the token or be an approved operator.
409      */
410     error ApprovalCallerNotOwnerNorApproved();
411 
412     /**
413      * The token does not exist.
414      */
415     error ApprovalQueryForNonexistentToken();
416 
417     /**
418      * Cannot query the balance for the zero address.
419      */
420     error BalanceQueryForZeroAddress();
421 
422     /**
423      * Cannot mint to the zero address.
424      */
425     error MintToZeroAddress();
426 
427     /**
428      * The quantity of tokens minted must be more than zero.
429      */
430     error MintZeroQuantity();
431 
432     /**
433      * The token does not exist.
434      */
435     error OwnerQueryForNonexistentToken();
436 
437     /**
438      * The caller must own the token or be an approved operator.
439      */
440     error TransferCallerNotOwnerNorApproved();
441 
442     /**
443      * The token must be owned by `from`.
444      */
445     error TransferFromIncorrectOwner();
446 
447     /**
448      * Cannot safely transfer to a contract that does not implement the
449      * ERC721Receiver interface.
450      */
451     error TransferToNonERC721ReceiverImplementer();
452 
453     /**
454      * Cannot transfer to the zero address.
455      */
456     error TransferToZeroAddress();
457 
458     /**
459      * The token does not exist.
460      */
461     error URIQueryForNonexistentToken();
462 
463     /**
464      * The `quantity` minted with ERC2309 exceeds the safety limit.
465      */
466     error MintERC2309QuantityExceedsLimit();
467 
468     /**
469      * The `extraData` cannot be set on an unintialized ownership slot.
470      */
471     error OwnershipNotInitializedForExtraData();
472 
473     // =============================================================
474     //                            STRUCTS
475     // =============================================================
476 
477     struct TokenOwnership {
478         // The address of the owner.
479         address addr;
480         // Stores the start time of ownership with minimal overhead for tokenomics.
481         uint64 startTimestamp;
482         // Whether the token has been burned.
483         bool burned;
484         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
485         uint24 extraData;
486     }
487 
488     // =============================================================
489     //                         TOKEN COUNTERS
490     // =============================================================
491 
492     /**
493      * @dev Returns the total number of tokens in existence.
494      * Burned tokens will reduce the count.
495      * To get the total number of tokens minted, please see {_totalMinted}.
496      */
497     function totalSupply() external view returns (uint256);
498 
499     // =============================================================
500     //                            IERC165
501     // =============================================================
502 
503     /**
504      * @dev Returns true if this contract implements the interface defined by
505      * `interfaceId`. See the corresponding
506      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
507      * to learn more about how these ids are created.
508      *
509      * This function call must use less than 30000 gas.
510      */
511     function supportsInterface(bytes4 interfaceId) external view returns (bool);
512 
513     // =============================================================
514     //                            IERC721
515     // =============================================================
516 
517     /**
518      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
519      */
520     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
521 
522     /**
523      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
524      */
525     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
526 
527     /**
528      * @dev Emitted when `owner` enables or disables
529      * (`approved`) `operator` to manage all of its assets.
530      */
531     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
532 
533     /**
534      * @dev Returns the number of tokens in `owner`'s account.
535      */
536     function balanceOf(address owner) external view returns (uint256 balance);
537 
538     /**
539      * @dev Returns the owner of the `tokenId` token.
540      *
541      * Requirements:
542      *
543      * - `tokenId` must exist.
544      */
545     function ownerOf(uint256 tokenId) external view returns (address owner);
546 
547     /**
548      * @dev Safely transfers `tokenId` token from `from` to `to`,
549      * checking first that contract recipients are aware of the ERC721 protocol
550      * to prevent tokens from being forever locked.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must exist and be owned by `from`.
557      * - If the caller is not `from`, it must be have been allowed to move
558      * this token by either {approve} or {setApprovalForAll}.
559      * - If `to` refers to a smart contract, it must implement
560      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
561      *
562      * Emits a {Transfer} event.
563      */
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId,
568         bytes calldata data
569     ) external payable;
570 
571     /**
572      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
573      */
574     function safeTransferFrom(
575         address from,
576         address to,
577         uint256 tokenId
578     ) external payable;
579 
580     /**
581      * @dev Transfers `tokenId` from `from` to `to`.
582      *
583      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
584      * whenever possible.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must be owned by `from`.
591      * - If the caller is not `from`, it must be approved to move this token
592      * by either {approve} or {setApprovalForAll}.
593      *
594      * Emits a {Transfer} event.
595      */
596     function transferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) external payable;
601 
602     /**
603      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
604      * The approval is cleared when the token is transferred.
605      *
606      * Only a single account can be approved at a time, so approving the
607      * zero address clears previous approvals.
608      *
609      * Requirements:
610      *
611      * - The caller must own the token or be an approved operator.
612      * - `tokenId` must exist.
613      *
614      * Emits an {Approval} event.
615      */
616     function approve(address to, uint256 tokenId) external payable;
617 
618     /**
619      * @dev Approve or remove `operator` as an operator for the caller.
620      * Operators can call {transferFrom} or {safeTransferFrom}
621      * for any token owned by the caller.
622      *
623      * Requirements:
624      *
625      * - The `operator` cannot be the caller.
626      *
627      * Emits an {ApprovalForAll} event.
628      */
629     function setApprovalForAll(address operator, bool _approved) external;
630 
631     /**
632      * @dev Returns the account approved for `tokenId` token.
633      *
634      * Requirements:
635      *
636      * - `tokenId` must exist.
637      */
638     function getApproved(uint256 tokenId) external view returns (address operator);
639 
640     /**
641      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
642      *
643      * See {setApprovalForAll}.
644      */
645     function isApprovedForAll(address owner, address operator) external view returns (bool);
646 
647     // =============================================================
648     //                        IERC721Metadata
649     // =============================================================
650 
651     /**
652      * @dev Returns the token collection name.
653      */
654     function name() external view returns (string memory);
655 
656     /**
657      * @dev Returns the token collection symbol.
658      */
659     function symbol() external view returns (string memory);
660 
661     /**
662      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
663      */
664     function tokenURI(uint256 tokenId) external view returns (string memory);
665 
666     // =============================================================
667     //                           IERC2309
668     // =============================================================
669 
670     /**
671      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
672      * (inclusive) is transferred from `from` to `to`, as defined in the
673      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
674      *
675      * See {_mintERC2309} for more details.
676      */
677     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
678 }
679 
680 // File: erc721a/contracts/ERC721A.sol
681 
682 
683 // ERC721A Contracts v4.2.3
684 // Creator: Chiru Labs
685 
686 pragma solidity ^0.8.4;
687 
688 
689 /**
690  * @dev Interface of ERC721 token receiver.
691  */
692 interface ERC721A__IERC721Receiver {
693     function onERC721Received(
694         address operator,
695         address from,
696         uint256 tokenId,
697         bytes calldata data
698     ) external returns (bytes4);
699 }
700 
701 /**
702  * @title ERC721A
703  *
704  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
705  * Non-Fungible Token Standard, including the Metadata extension.
706  * Optimized for lower gas during batch mints.
707  *
708  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
709  * starting from `_startTokenId()`.
710  *
711  * Assumptions:
712  *
713  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
714  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
715  */
716 contract ERC721A is IERC721A {
717     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
718     struct TokenApprovalRef {
719         address value;
720     }
721 
722     // =============================================================
723     //                           CONSTANTS
724     // =============================================================
725 
726     // Mask of an entry in packed address data.
727     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
728 
729     // The bit position of `numberMinted` in packed address data.
730     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
731 
732     // The bit position of `numberBurned` in packed address data.
733     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
734 
735     // The bit position of `aux` in packed address data.
736     uint256 private constant _BITPOS_AUX = 192;
737 
738     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
739     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
740 
741     // The bit position of `startTimestamp` in packed ownership.
742     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
743 
744     // The bit mask of the `burned` bit in packed ownership.
745     uint256 private constant _BITMASK_BURNED = 1 << 224;
746 
747     // The bit position of the `nextInitialized` bit in packed ownership.
748     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
749 
750     // The bit mask of the `nextInitialized` bit in packed ownership.
751     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
752 
753     // The bit position of `extraData` in packed ownership.
754     uint256 private constant _BITPOS_EXTRA_DATA = 232;
755 
756     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
757     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
758 
759     // The mask of the lower 160 bits for addresses.
760     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
761 
762     // The maximum `quantity` that can be minted with {_mintERC2309}.
763     // This limit is to prevent overflows on the address data entries.
764     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
765     // is required to cause an overflow, which is unrealistic.
766     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
767 
768     // The `Transfer` event signature is given by:
769     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
770     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
771         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
772 
773     // =============================================================
774     //                            STORAGE
775     // =============================================================
776 
777     // The next token ID to be minted.
778     uint256 private _currentIndex;
779 
780     // The number of tokens burned.
781     uint256 private _burnCounter;
782 
783     // Token name
784     string private _name;
785 
786     // Token symbol
787     string private _symbol;
788 
789     // Mapping from token ID to ownership details
790     // An empty struct value does not necessarily mean the token is unowned.
791     // See {_packedOwnershipOf} implementation for details.
792     //
793     // Bits Layout:
794     // - [0..159]   `addr`
795     // - [160..223] `startTimestamp`
796     // - [224]      `burned`
797     // - [225]      `nextInitialized`
798     // - [232..255] `extraData`
799     mapping(uint256 => uint256) private _packedOwnerships;
800 
801     // Mapping owner address to address data.
802     //
803     // Bits Layout:
804     // - [0..63]    `balance`
805     // - [64..127]  `numberMinted`
806     // - [128..191] `numberBurned`
807     // - [192..255] `aux`
808     mapping(address => uint256) private _packedAddressData;
809 
810     // Mapping from token ID to approved address.
811     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
812 
813     // Mapping from owner to operator approvals
814     mapping(address => mapping(address => bool)) private _operatorApprovals;
815 
816     // =============================================================
817     //                          CONSTRUCTOR
818     // =============================================================
819 
820     constructor(string memory name_, string memory symbol_) {
821         _name = name_;
822         _symbol = symbol_;
823         _currentIndex = _startTokenId();
824     }
825 
826     // =============================================================
827     //                   TOKEN COUNTING OPERATIONS
828     // =============================================================
829 
830     /**
831      * @dev Returns the starting token ID.
832      * To change the starting token ID, please override this function.
833      */
834     function _startTokenId() internal view virtual returns (uint256) {
835         return 0;
836     }
837 
838     /**
839      * @dev Returns the next token ID to be minted.
840      */
841     function _nextTokenId() internal view virtual returns (uint256) {
842         return _currentIndex;
843     }
844 
845     /**
846      * @dev Returns the total number of tokens in existence.
847      * Burned tokens will reduce the count.
848      * To get the total number of tokens minted, please see {_totalMinted}.
849      */
850     function totalSupply() public view virtual override returns (uint256) {
851         // Counter underflow is impossible as _burnCounter cannot be incremented
852         // more than `_currentIndex - _startTokenId()` times.
853         unchecked {
854             return _currentIndex - _burnCounter - _startTokenId();
855         }
856     }
857 
858     /**
859      * @dev Returns the total amount of tokens minted in the contract.
860      */
861     function _totalMinted() internal view virtual returns (uint256) {
862         // Counter underflow is impossible as `_currentIndex` does not decrement,
863         // and it is initialized to `_startTokenId()`.
864         unchecked {
865             return _currentIndex - _startTokenId();
866         }
867     }
868 
869     /**
870      * @dev Returns the total number of tokens burned.
871      */
872     function _totalBurned() internal view virtual returns (uint256) {
873         return _burnCounter;
874     }
875 
876     // =============================================================
877     //                    ADDRESS DATA OPERATIONS
878     // =============================================================
879 
880     /**
881      * @dev Returns the number of tokens in `owner`'s account.
882      */
883     function balanceOf(address owner) public view virtual override returns (uint256) {
884         if (owner == address(0)) revert BalanceQueryForZeroAddress();
885         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
886     }
887 
888     /**
889      * Returns the number of tokens minted by `owner`.
890      */
891     function _numberMinted(address owner) internal view returns (uint256) {
892         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
893     }
894 
895     /**
896      * Returns the number of tokens burned by or on behalf of `owner`.
897      */
898     function _numberBurned(address owner) internal view returns (uint256) {
899         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
900     }
901 
902     /**
903      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
904      */
905     function _getAux(address owner) internal view returns (uint64) {
906         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
907     }
908 
909     /**
910      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
911      * If there are multiple variables, please pack them into a uint64.
912      */
913     function _setAux(address owner, uint64 aux) internal virtual {
914         uint256 packed = _packedAddressData[owner];
915         uint256 auxCasted;
916         // Cast `aux` with assembly to avoid redundant masking.
917         assembly {
918             auxCasted := aux
919         }
920         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
921         _packedAddressData[owner] = packed;
922     }
923 
924     // =============================================================
925     //                            IERC165
926     // =============================================================
927 
928     /**
929      * @dev Returns true if this contract implements the interface defined by
930      * `interfaceId`. See the corresponding
931      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
932      * to learn more about how these ids are created.
933      *
934      * This function call must use less than 30000 gas.
935      */
936     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
937         // The interface IDs are constants representing the first 4 bytes
938         // of the XOR of all function selectors in the interface.
939         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
940         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
941         return
942             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
943             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
944             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
945     }
946 
947     // =============================================================
948     //                        IERC721Metadata
949     // =============================================================
950 
951     /**
952      * @dev Returns the token collection name.
953      */
954     function name() public view virtual override returns (string memory) {
955         return _name;
956     }
957 
958     /**
959      * @dev Returns the token collection symbol.
960      */
961     function symbol() public view virtual override returns (string memory) {
962         return _symbol;
963     }
964 
965     /**
966      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
967      */
968     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
969         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
970 
971         string memory baseURI = _baseURI();
972         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
973     }
974 
975     /**
976      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
977      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
978      * by default, it can be overridden in child contracts.
979      */
980     function _baseURI() internal view virtual returns (string memory) {
981         return '';
982     }
983 
984     // =============================================================
985     //                     OWNERSHIPS OPERATIONS
986     // =============================================================
987 
988     /**
989      * @dev Returns the owner of the `tokenId` token.
990      *
991      * Requirements:
992      *
993      * - `tokenId` must exist.
994      */
995     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
996         return address(uint160(_packedOwnershipOf(tokenId)));
997     }
998 
999     /**
1000      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1001      * It gradually moves to O(1) as tokens get transferred around over time.
1002      */
1003     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1004         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1005     }
1006 
1007     /**
1008      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1009      */
1010     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1011         return _unpackedOwnership(_packedOwnerships[index]);
1012     }
1013 
1014     /**
1015      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1016      */
1017     function _initializeOwnershipAt(uint256 index) internal virtual {
1018         if (_packedOwnerships[index] == 0) {
1019             _packedOwnerships[index] = _packedOwnershipOf(index);
1020         }
1021     }
1022 
1023     /**
1024      * Returns the packed ownership data of `tokenId`.
1025      */
1026     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1027         uint256 curr = tokenId;
1028 
1029         unchecked {
1030             if (_startTokenId() <= curr)
1031                 if (curr < _currentIndex) {
1032                     uint256 packed = _packedOwnerships[curr];
1033                     // If not burned.
1034                     if (packed & _BITMASK_BURNED == 0) {
1035                         // Invariant:
1036                         // There will always be an initialized ownership slot
1037                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1038                         // before an unintialized ownership slot
1039                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1040                         // Hence, `curr` will not underflow.
1041                         //
1042                         // We can directly compare the packed value.
1043                         // If the address is zero, packed will be zero.
1044                         while (packed == 0) {
1045                             packed = _packedOwnerships[--curr];
1046                         }
1047                         return packed;
1048                     }
1049                 }
1050         }
1051         revert OwnerQueryForNonexistentToken();
1052     }
1053 
1054     /**
1055      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1056      */
1057     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1058         ownership.addr = address(uint160(packed));
1059         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1060         ownership.burned = packed & _BITMASK_BURNED != 0;
1061         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1062     }
1063 
1064     /**
1065      * @dev Packs ownership data into a single uint256.
1066      */
1067     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1068         assembly {
1069             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1070             owner := and(owner, _BITMASK_ADDRESS)
1071             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1072             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1073         }
1074     }
1075 
1076     /**
1077      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1078      */
1079     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1080         // For branchless setting of the `nextInitialized` flag.
1081         assembly {
1082             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1083             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1084         }
1085     }
1086 
1087     // =============================================================
1088     //                      APPROVAL OPERATIONS
1089     // =============================================================
1090 
1091     /**
1092      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1093      * The approval is cleared when the token is transferred.
1094      *
1095      * Only a single account can be approved at a time, so approving the
1096      * zero address clears previous approvals.
1097      *
1098      * Requirements:
1099      *
1100      * - The caller must own the token or be an approved operator.
1101      * - `tokenId` must exist.
1102      *
1103      * Emits an {Approval} event.
1104      */
1105     function approve(address to, uint256 tokenId) public payable virtual override {
1106         address owner = ownerOf(tokenId);
1107 
1108         if (_msgSenderERC721A() != owner)
1109             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1110                 revert ApprovalCallerNotOwnerNorApproved();
1111             }
1112 
1113         _tokenApprovals[tokenId].value = to;
1114         emit Approval(owner, to, tokenId);
1115     }
1116 
1117     /**
1118      * @dev Returns the account approved for `tokenId` token.
1119      *
1120      * Requirements:
1121      *
1122      * - `tokenId` must exist.
1123      */
1124     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1125         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1126 
1127         return _tokenApprovals[tokenId].value;
1128     }
1129 
1130     /**
1131      * @dev Approve or remove `operator` as an operator for the caller.
1132      * Operators can call {transferFrom} or {safeTransferFrom}
1133      * for any token owned by the caller.
1134      *
1135      * Requirements:
1136      *
1137      * - The `operator` cannot be the caller.
1138      *
1139      * Emits an {ApprovalForAll} event.
1140      */
1141     function setApprovalForAll(address operator, bool approved) public virtual override {
1142         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1143         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1144     }
1145 
1146     /**
1147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1148      *
1149      * See {setApprovalForAll}.
1150      */
1151     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1152         return _operatorApprovals[owner][operator];
1153     }
1154 
1155     /**
1156      * @dev Returns whether `tokenId` exists.
1157      *
1158      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1159      *
1160      * Tokens start existing when they are minted. See {_mint}.
1161      */
1162     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1163         return
1164             _startTokenId() <= tokenId &&
1165             tokenId < _currentIndex && // If within bounds,
1166             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1167     }
1168 
1169     /**
1170      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1171      */
1172     function _isSenderApprovedOrOwner(
1173         address approvedAddress,
1174         address owner,
1175         address msgSender
1176     ) private pure returns (bool result) {
1177         assembly {
1178             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1179             owner := and(owner, _BITMASK_ADDRESS)
1180             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1181             msgSender := and(msgSender, _BITMASK_ADDRESS)
1182             // `msgSender == owner || msgSender == approvedAddress`.
1183             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1184         }
1185     }
1186 
1187     /**
1188      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1189      */
1190     function _getApprovedSlotAndAddress(uint256 tokenId)
1191         private
1192         view
1193         returns (uint256 approvedAddressSlot, address approvedAddress)
1194     {
1195         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1196         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1197         assembly {
1198             approvedAddressSlot := tokenApproval.slot
1199             approvedAddress := sload(approvedAddressSlot)
1200         }
1201     }
1202 
1203     // =============================================================
1204     //                      TRANSFER OPERATIONS
1205     // =============================================================
1206 
1207     /**
1208      * @dev Transfers `tokenId` from `from` to `to`.
1209      *
1210      * Requirements:
1211      *
1212      * - `from` cannot be the zero address.
1213      * - `to` cannot be the zero address.
1214      * - `tokenId` token must be owned by `from`.
1215      * - If the caller is not `from`, it must be approved to move this token
1216      * by either {approve} or {setApprovalForAll}.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function transferFrom(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) public payable virtual override {
1225         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1226 
1227         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1228 
1229         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1230 
1231         // The nested ifs save around 20+ gas over a compound boolean condition.
1232         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1233             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1234 
1235         if (to == address(0)) revert TransferToZeroAddress();
1236 
1237         _beforeTokenTransfers(from, to, tokenId, 1);
1238 
1239         // Clear approvals from the previous owner.
1240         assembly {
1241             if approvedAddress {
1242                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1243                 sstore(approvedAddressSlot, 0)
1244             }
1245         }
1246 
1247         // Underflow of the sender's balance is impossible because we check for
1248         // ownership above and the recipient's balance can't realistically overflow.
1249         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1250         unchecked {
1251             // We can directly increment and decrement the balances.
1252             --_packedAddressData[from]; // Updates: `balance -= 1`.
1253             ++_packedAddressData[to]; // Updates: `balance += 1`.
1254 
1255             // Updates:
1256             // - `address` to the next owner.
1257             // - `startTimestamp` to the timestamp of transfering.
1258             // - `burned` to `false`.
1259             // - `nextInitialized` to `true`.
1260             _packedOwnerships[tokenId] = _packOwnershipData(
1261                 to,
1262                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1263             );
1264 
1265             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1266             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1267                 uint256 nextTokenId = tokenId + 1;
1268                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1269                 if (_packedOwnerships[nextTokenId] == 0) {
1270                     // If the next slot is within bounds.
1271                     if (nextTokenId != _currentIndex) {
1272                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1273                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1274                     }
1275                 }
1276             }
1277         }
1278 
1279         emit Transfer(from, to, tokenId);
1280         _afterTokenTransfers(from, to, tokenId, 1);
1281     }
1282 
1283     /**
1284      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1285      */
1286     function safeTransferFrom(
1287         address from,
1288         address to,
1289         uint256 tokenId
1290     ) public payable virtual override {
1291         safeTransferFrom(from, to, tokenId, '');
1292     }
1293 
1294     /**
1295      * @dev Safely transfers `tokenId` token from `from` to `to`.
1296      *
1297      * Requirements:
1298      *
1299      * - `from` cannot be the zero address.
1300      * - `to` cannot be the zero address.
1301      * - `tokenId` token must exist and be owned by `from`.
1302      * - If the caller is not `from`, it must be approved to move this token
1303      * by either {approve} or {setApprovalForAll}.
1304      * - If `to` refers to a smart contract, it must implement
1305      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1306      *
1307      * Emits a {Transfer} event.
1308      */
1309     function safeTransferFrom(
1310         address from,
1311         address to,
1312         uint256 tokenId,
1313         bytes memory _data
1314     ) public payable virtual override {
1315         transferFrom(from, to, tokenId);
1316         if (to.code.length != 0)
1317             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1318                 revert TransferToNonERC721ReceiverImplementer();
1319             }
1320     }
1321 
1322     /**
1323      * @dev Hook that is called before a set of serially-ordered token IDs
1324      * are about to be transferred. This includes minting.
1325      * And also called before burning one token.
1326      *
1327      * `startTokenId` - the first token ID to be transferred.
1328      * `quantity` - the amount to be transferred.
1329      *
1330      * Calling conditions:
1331      *
1332      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1333      * transferred to `to`.
1334      * - When `from` is zero, `tokenId` will be minted for `to`.
1335      * - When `to` is zero, `tokenId` will be burned by `from`.
1336      * - `from` and `to` are never both zero.
1337      */
1338     function _beforeTokenTransfers(
1339         address from,
1340         address to,
1341         uint256 startTokenId,
1342         uint256 quantity
1343     ) internal virtual {}
1344 
1345     /**
1346      * @dev Hook that is called after a set of serially-ordered token IDs
1347      * have been transferred. This includes minting.
1348      * And also called after one token has been burned.
1349      *
1350      * `startTokenId` - the first token ID to be transferred.
1351      * `quantity` - the amount to be transferred.
1352      *
1353      * Calling conditions:
1354      *
1355      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1356      * transferred to `to`.
1357      * - When `from` is zero, `tokenId` has been minted for `to`.
1358      * - When `to` is zero, `tokenId` has been burned by `from`.
1359      * - `from` and `to` are never both zero.
1360      */
1361     function _afterTokenTransfers(
1362         address from,
1363         address to,
1364         uint256 startTokenId,
1365         uint256 quantity
1366     ) internal virtual {}
1367 
1368     /**
1369      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1370      *
1371      * `from` - Previous owner of the given token ID.
1372      * `to` - Target address that will receive the token.
1373      * `tokenId` - Token ID to be transferred.
1374      * `_data` - Optional data to send along with the call.
1375      *
1376      * Returns whether the call correctly returned the expected magic value.
1377      */
1378     function _checkContractOnERC721Received(
1379         address from,
1380         address to,
1381         uint256 tokenId,
1382         bytes memory _data
1383     ) private returns (bool) {
1384         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1385             bytes4 retval
1386         ) {
1387             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1388         } catch (bytes memory reason) {
1389             if (reason.length == 0) {
1390                 revert TransferToNonERC721ReceiverImplementer();
1391             } else {
1392                 assembly {
1393                     revert(add(32, reason), mload(reason))
1394                 }
1395             }
1396         }
1397     }
1398 
1399     // =============================================================
1400     //                        MINT OPERATIONS
1401     // =============================================================
1402 
1403     /**
1404      * @dev Mints `quantity` tokens and transfers them to `to`.
1405      *
1406      * Requirements:
1407      *
1408      * - `to` cannot be the zero address.
1409      * - `quantity` must be greater than 0.
1410      *
1411      * Emits a {Transfer} event for each mint.
1412      */
1413     function _mint(address to, uint256 quantity) internal virtual {
1414         uint256 startTokenId = _currentIndex;
1415         if (quantity == 0) revert MintZeroQuantity();
1416 
1417         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1418 
1419         // Overflows are incredibly unrealistic.
1420         // `balance` and `numberMinted` have a maximum limit of 2**64.
1421         // `tokenId` has a maximum limit of 2**256.
1422         unchecked {
1423             // Updates:
1424             // - `balance += quantity`.
1425             // - `numberMinted += quantity`.
1426             //
1427             // We can directly add to the `balance` and `numberMinted`.
1428             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1429 
1430             // Updates:
1431             // - `address` to the owner.
1432             // - `startTimestamp` to the timestamp of minting.
1433             // - `burned` to `false`.
1434             // - `nextInitialized` to `quantity == 1`.
1435             _packedOwnerships[startTokenId] = _packOwnershipData(
1436                 to,
1437                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1438             );
1439 
1440             uint256 toMasked;
1441             uint256 end = startTokenId + quantity;
1442 
1443             // Use assembly to loop and emit the `Transfer` event for gas savings.
1444             // The duplicated `log4` removes an extra check and reduces stack juggling.
1445             // The assembly, together with the surrounding Solidity code, have been
1446             // delicately arranged to nudge the compiler into producing optimized opcodes.
1447             assembly {
1448                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1449                 toMasked := and(to, _BITMASK_ADDRESS)
1450                 // Emit the `Transfer` event.
1451                 log4(
1452                     0, // Start of data (0, since no data).
1453                     0, // End of data (0, since no data).
1454                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1455                     0, // `address(0)`.
1456                     toMasked, // `to`.
1457                     startTokenId // `tokenId`.
1458                 )
1459 
1460                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1461                 // that overflows uint256 will make the loop run out of gas.
1462                 // The compiler will optimize the `iszero` away for performance.
1463                 for {
1464                     let tokenId := add(startTokenId, 1)
1465                 } iszero(eq(tokenId, end)) {
1466                     tokenId := add(tokenId, 1)
1467                 } {
1468                     // Emit the `Transfer` event. Similar to above.
1469                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1470                 }
1471             }
1472             if (toMasked == 0) revert MintToZeroAddress();
1473 
1474             _currentIndex = end;
1475         }
1476         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1477     }
1478 
1479     /**
1480      * @dev Mints `quantity` tokens and transfers them to `to`.
1481      *
1482      * This function is intended for efficient minting only during contract creation.
1483      *
1484      * It emits only one {ConsecutiveTransfer} as defined in
1485      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1486      * instead of a sequence of {Transfer} event(s).
1487      *
1488      * Calling this function outside of contract creation WILL make your contract
1489      * non-compliant with the ERC721 standard.
1490      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1491      * {ConsecutiveTransfer} event is only permissible during contract creation.
1492      *
1493      * Requirements:
1494      *
1495      * - `to` cannot be the zero address.
1496      * - `quantity` must be greater than 0.
1497      *
1498      * Emits a {ConsecutiveTransfer} event.
1499      */
1500     function _mintERC2309(address to, uint256 quantity) internal virtual {
1501         uint256 startTokenId = _currentIndex;
1502         if (to == address(0)) revert MintToZeroAddress();
1503         if (quantity == 0) revert MintZeroQuantity();
1504         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1505 
1506         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1507 
1508         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1509         unchecked {
1510             // Updates:
1511             // - `balance += quantity`.
1512             // - `numberMinted += quantity`.
1513             //
1514             // We can directly add to the `balance` and `numberMinted`.
1515             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1516 
1517             // Updates:
1518             // - `address` to the owner.
1519             // - `startTimestamp` to the timestamp of minting.
1520             // - `burned` to `false`.
1521             // - `nextInitialized` to `quantity == 1`.
1522             _packedOwnerships[startTokenId] = _packOwnershipData(
1523                 to,
1524                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1525             );
1526 
1527             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1528 
1529             _currentIndex = startTokenId + quantity;
1530         }
1531         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1532     }
1533 
1534     /**
1535      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1536      *
1537      * Requirements:
1538      *
1539      * - If `to` refers to a smart contract, it must implement
1540      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1541      * - `quantity` must be greater than 0.
1542      *
1543      * See {_mint}.
1544      *
1545      * Emits a {Transfer} event for each mint.
1546      */
1547     function _safeMint(
1548         address to,
1549         uint256 quantity,
1550         bytes memory _data
1551     ) internal virtual {
1552         _mint(to, quantity);
1553 
1554         unchecked {
1555             if (to.code.length != 0) {
1556                 uint256 end = _currentIndex;
1557                 uint256 index = end - quantity;
1558                 do {
1559                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1560                         revert TransferToNonERC721ReceiverImplementer();
1561                     }
1562                 } while (index < end);
1563                 // Reentrancy protection.
1564                 if (_currentIndex != end) revert();
1565             }
1566         }
1567     }
1568 
1569     /**
1570      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1571      */
1572     function _safeMint(address to, uint256 quantity) internal virtual {
1573         _safeMint(to, quantity, '');
1574     }
1575 
1576     // =============================================================
1577     //                        BURN OPERATIONS
1578     // =============================================================
1579 
1580     /**
1581      * @dev Equivalent to `_burn(tokenId, false)`.
1582      */
1583     function _burn(uint256 tokenId) internal virtual {
1584         _burn(tokenId, false);
1585     }
1586 
1587     /**
1588      * @dev Destroys `tokenId`.
1589      * The approval is cleared when the token is burned.
1590      *
1591      * Requirements:
1592      *
1593      * - `tokenId` must exist.
1594      *
1595      * Emits a {Transfer} event.
1596      */
1597     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1598         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1599 
1600         address from = address(uint160(prevOwnershipPacked));
1601 
1602         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1603 
1604         if (approvalCheck) {
1605             // The nested ifs save around 20+ gas over a compound boolean condition.
1606             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1607                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1608         }
1609 
1610         _beforeTokenTransfers(from, address(0), tokenId, 1);
1611 
1612         // Clear approvals from the previous owner.
1613         assembly {
1614             if approvedAddress {
1615                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1616                 sstore(approvedAddressSlot, 0)
1617             }
1618         }
1619 
1620         // Underflow of the sender's balance is impossible because we check for
1621         // ownership above and the recipient's balance can't realistically overflow.
1622         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1623         unchecked {
1624             // Updates:
1625             // - `balance -= 1`.
1626             // - `numberBurned += 1`.
1627             //
1628             // We can directly decrement the balance, and increment the number burned.
1629             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1630             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1631 
1632             // Updates:
1633             // - `address` to the last owner.
1634             // - `startTimestamp` to the timestamp of burning.
1635             // - `burned` to `true`.
1636             // - `nextInitialized` to `true`.
1637             _packedOwnerships[tokenId] = _packOwnershipData(
1638                 from,
1639                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1640             );
1641 
1642             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1643             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1644                 uint256 nextTokenId = tokenId + 1;
1645                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1646                 if (_packedOwnerships[nextTokenId] == 0) {
1647                     // If the next slot is within bounds.
1648                     if (nextTokenId != _currentIndex) {
1649                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1650                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1651                     }
1652                 }
1653             }
1654         }
1655 
1656         emit Transfer(from, address(0), tokenId);
1657         _afterTokenTransfers(from, address(0), tokenId, 1);
1658 
1659         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1660         unchecked {
1661             _burnCounter++;
1662         }
1663     }
1664 
1665     // =============================================================
1666     //                     EXTRA DATA OPERATIONS
1667     // =============================================================
1668 
1669     /**
1670      * @dev Directly sets the extra data for the ownership data `index`.
1671      */
1672     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1673         uint256 packed = _packedOwnerships[index];
1674         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1675         uint256 extraDataCasted;
1676         // Cast `extraData` with assembly to avoid redundant masking.
1677         assembly {
1678             extraDataCasted := extraData
1679         }
1680         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1681         _packedOwnerships[index] = packed;
1682     }
1683 
1684     /**
1685      * @dev Called during each token transfer to set the 24bit `extraData` field.
1686      * Intended to be overridden by the cosumer contract.
1687      *
1688      * `previousExtraData` - the value of `extraData` before transfer.
1689      *
1690      * Calling conditions:
1691      *
1692      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1693      * transferred to `to`.
1694      * - When `from` is zero, `tokenId` will be minted for `to`.
1695      * - When `to` is zero, `tokenId` will be burned by `from`.
1696      * - `from` and `to` are never both zero.
1697      */
1698     function _extraData(
1699         address from,
1700         address to,
1701         uint24 previousExtraData
1702     ) internal view virtual returns (uint24) {}
1703 
1704     /**
1705      * @dev Returns the next extra data for the packed ownership data.
1706      * The returned result is shifted into position.
1707      */
1708     function _nextExtraData(
1709         address from,
1710         address to,
1711         uint256 prevOwnershipPacked
1712     ) private view returns (uint256) {
1713         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1714         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1715     }
1716 
1717     // =============================================================
1718     //                       OTHER OPERATIONS
1719     // =============================================================
1720 
1721     /**
1722      * @dev Returns the message sender (defaults to `msg.sender`).
1723      *
1724      * If you are writing GSN compatible contracts, you need to override this function.
1725      */
1726     function _msgSenderERC721A() internal view virtual returns (address) {
1727         return msg.sender;
1728     }
1729 
1730     /**
1731      * @dev Converts a uint256 to its ASCII string decimal representation.
1732      */
1733     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1734         assembly {
1735             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1736             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1737             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1738             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1739             let m := add(mload(0x40), 0xa0)
1740             // Update the free memory pointer to allocate.
1741             mstore(0x40, m)
1742             // Assign the `str` to the end.
1743             str := sub(m, 0x20)
1744             // Zeroize the slot after the string.
1745             mstore(str, 0)
1746 
1747             // Cache the end of the memory to calculate the length later.
1748             let end := str
1749 
1750             // We write the string from rightmost digit to leftmost digit.
1751             // The following is essentially a do-while loop that also handles the zero case.
1752             // prettier-ignore
1753             for { let temp := value } 1 {} {
1754                 str := sub(str, 1)
1755                 // Write the character to the pointer.
1756                 // The ASCII index of the '0' character is 48.
1757                 mstore8(str, add(48, mod(temp, 10)))
1758                 // Keep dividing `temp` until zero.
1759                 temp := div(temp, 10)
1760                 // prettier-ignore
1761                 if iszero(temp) { break }
1762             }
1763 
1764             let length := sub(end, str)
1765             // Move the pointer 32 bytes leftwards to make room for the length.
1766             str := sub(str, 0x20)
1767             // Store the length.
1768             mstore(str, length)
1769         }
1770     }
1771 }
1772 
1773 // File: minicombat.sol
1774 
1775 
1776 
1777 //Developer : FazelPejmanfar , Twitter :@Pejmanfarfazel
1778 
1779 
1780 
1781 pragma solidity >=0.7.0 <0.9.0;
1782 
1783 
1784 
1785 
1786 
1787 contract MiniCombat is ERC721A, Ownable, ReentrancyGuard {
1788 
1789 
1790   string public baseURI;
1791   string public notRevealedUri = "ipfs://bafkreiaseedvv3e7p2uaormwnoc5ejdvr6mif6fitugtfnolf4idux7koa";
1792   uint256 public cost = 0.01 ether;
1793   uint256 public maxSupply = 999;
1794   uint256 public MaxperWallet = 1;
1795   bool public paused = true;
1796   bool public revealed = false;
1797   bool public preSale = true;
1798   bytes32 public merkleRoot;
1799 
1800   constructor() ERC721A("MiniCombat", "Mcom") {}
1801 
1802   // internal
1803   function _baseURI() internal view virtual override returns (string memory) {
1804     return baseURI;
1805   }
1806       function _startTokenId() internal view virtual override returns (uint256) {
1807         return 1;
1808     }
1809 
1810   // public
1811   /// @dev Public mint 
1812   function mint(uint256 tokens) public payable nonReentrant {
1813     require(!paused, "Mcom: oops contract is paused");
1814     require(!preSale, "Mcom: Public Sale Hasn't started yet");
1815     require(tokens <= MaxperWallet, "Mcom: max mint amount per tx exceeded");
1816     require(totalSupply() + tokens <= maxSupply, "Mcom: We Soldout");
1817     require(_numberMinted(_msgSenderERC721A()) + tokens <= MaxperWallet, "Mcom: Max NFT Per Wallet exceeded");
1818     require(msg.value >= cost * tokens, "Mcom: insufficient funds");
1819 
1820       _safeMint(_msgSenderERC721A(), tokens);
1821     
1822   }
1823 /// @dev presale mint for whitelisted
1824     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public payable nonReentrant {
1825     require(!paused, "Mcom: oops contract is paused");
1826     require(preSale, "Mcom: Presale Hasn't started yet");
1827     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Mcom: You are not Whitelisted");
1828     require(_numberMinted(_msgSenderERC721A()) + tokens <= MaxperWallet, "Mcom: Max NFT Per Wallet exceeded");
1829     require(tokens <= MaxperWallet, "Mcom: max mint per Tx exceeded");
1830     require(totalSupply() + tokens <= maxSupply, "Mcom: Whitelist MaxSupply exceeded");
1831     require(msg.value >= cost * tokens, "Mcom: insufficient funds");
1832 
1833       _safeMint(_msgSenderERC721A(), tokens);
1834     
1835   }
1836 
1837   /// @dev use it for giveaway and team mint
1838      function airdrop(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
1839     require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
1840 
1841       _safeMint(destination, _mintAmount);
1842   }
1843 
1844 /// @notice returns metadata link of tokenid
1845   function tokenURI(uint256 tokenId)
1846     public
1847     view
1848     virtual
1849     override
1850     returns (string memory)
1851   {
1852     require(
1853       _exists(tokenId),
1854       "ERC721AMetadata: URI query for nonexistent token"
1855     );
1856     
1857     if(revealed == false) {
1858         return notRevealedUri;
1859     }
1860 
1861     string memory currentBaseURI = _baseURI();
1862     return bytes(currentBaseURI).length > 0
1863         ? string(abi.encodePacked(currentBaseURI, _toString(tokenId), ".json"))
1864         : "";
1865   }
1866 
1867      /// @notice return the number minted by an address
1868     function numberMinted(address owner) public view returns (uint256) {
1869     return _numberMinted(owner);
1870   }
1871 
1872     /// @notice return the tokens owned by an address
1873       function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1874         unchecked {
1875             uint256 tokenIdsIdx;
1876             address currOwnershipAddr;
1877             uint256 tokenIdsLength = balanceOf(owner);
1878             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1879             TokenOwnership memory ownership;
1880             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1881                 ownership = _ownershipAt(i);
1882                 if (ownership.burned) {
1883                     continue;
1884                 }
1885                 if (ownership.addr != address(0)) {
1886                     currOwnershipAddr = ownership.addr;
1887                 }
1888                 if (currOwnershipAddr == owner) {
1889                     tokenIds[tokenIdsIdx++] = i;
1890                 }
1891             }
1892             return tokenIds;
1893         }
1894     }
1895 
1896   //only owner
1897   function reveal(bool _state) public onlyOwner {
1898       revealed = _state;
1899   }
1900 
1901     /// @dev change the merkle root for the whitelist phase
1902   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1903         merkleRoot = _merkleRoot;
1904     }
1905 
1906   /// @dev change the public max per wallet
1907   function setMaxPerWallet(uint256 _limit) public onlyOwner {
1908     MaxperWallet = _limit;
1909   }
1910 
1911    /// @dev change the public price(amount need to be in wei)
1912   function setCost(uint256 _newCost) public onlyOwner {
1913     cost = _newCost;
1914   }
1915 
1916   /// @dev cut the supply if we dont sold out
1917     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1918     maxSupply = _newsupply;
1919   }
1920 
1921 
1922  /// @dev set your baseuri
1923   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1924     baseURI = _newBaseURI;
1925   }
1926 
1927    /// @dev set hidden uri
1928   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1929     notRevealedUri = _notRevealedURI;
1930   }
1931 
1932  /// @dev to pause and unpause your contract(use booleans true or false)
1933   function pause(bool _state) public onlyOwner {
1934     paused = _state;
1935   }
1936 
1937      /// @dev activate whitelist sale(use booleans true or false)
1938     function togglepreSale(bool _state) external onlyOwner {
1939         preSale = _state;
1940     }
1941   
1942   /// @dev withdraw funds from contract
1943   function withdraw() public payable onlyOwner nonReentrant {
1944       uint256 balance = address(this).balance;
1945       payable(_msgSenderERC721A()).transfer(balance);
1946   }
1947 }