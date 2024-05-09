1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
69 
70 
71 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev These functions deal with verification of Merkle Tree proofs.
77  *
78  * The proofs can be generated using the JavaScript library
79  * https://github.com/miguelmota/merkletreejs[merkletreejs].
80  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
81  *
82  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
83  *
84  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
85  * hashing, or use a hash function other than keccak256 for hashing leaves.
86  * This is because the concatenation of a sorted pair of internal nodes in
87  * the merkle tree could be reinterpreted as a leaf value.
88  */
89 library MerkleProof {
90     /**
91      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
92      * defined by `root`. For this, a `proof` must be provided, containing
93      * sibling hashes on the branch from the leaf to the root of the tree. Each
94      * pair of leaves and each pair of pre-images are assumed to be sorted.
95      */
96     function verify(
97         bytes32[] memory proof,
98         bytes32 root,
99         bytes32 leaf
100     ) internal pure returns (bool) {
101         return processProof(proof, leaf) == root;
102     }
103 
104     /**
105      * @dev Calldata version of {verify}
106      *
107      * _Available since v4.7._
108      */
109     function verifyCalldata(
110         bytes32[] calldata proof,
111         bytes32 root,
112         bytes32 leaf
113     ) internal pure returns (bool) {
114         return processProofCalldata(proof, leaf) == root;
115     }
116 
117     /**
118      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
119      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
120      * hash matches the root of the tree. When processing the proof, the pairs
121      * of leafs & pre-images are assumed to be sorted.
122      *
123      * _Available since v4.4._
124      */
125     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
126         bytes32 computedHash = leaf;
127         for (uint256 i = 0; i < proof.length; i++) {
128             computedHash = _hashPair(computedHash, proof[i]);
129         }
130         return computedHash;
131     }
132 
133     /**
134      * @dev Calldata version of {processProof}
135      *
136      * _Available since v4.7._
137      */
138     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
139         bytes32 computedHash = leaf;
140         for (uint256 i = 0; i < proof.length; i++) {
141             computedHash = _hashPair(computedHash, proof[i]);
142         }
143         return computedHash;
144     }
145 
146     /**
147      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
148      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
149      *
150      * _Available since v4.7._
151      */
152     function multiProofVerify(
153         bytes32[] memory proof,
154         bool[] memory proofFlags,
155         bytes32 root,
156         bytes32[] memory leaves
157     ) internal pure returns (bool) {
158         return processMultiProof(proof, proofFlags, leaves) == root;
159     }
160 
161     /**
162      * @dev Calldata version of {multiProofVerify}
163      *
164      * _Available since v4.7._
165      */
166     function multiProofVerifyCalldata(
167         bytes32[] calldata proof,
168         bool[] calldata proofFlags,
169         bytes32 root,
170         bytes32[] memory leaves
171     ) internal pure returns (bool) {
172         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
173     }
174 
175     /**
176      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
177      * consuming from one or the other at each step according to the instructions given by
178      * `proofFlags`.
179      *
180      * _Available since v4.7._
181      */
182     function processMultiProof(
183         bytes32[] memory proof,
184         bool[] memory proofFlags,
185         bytes32[] memory leaves
186     ) internal pure returns (bytes32 merkleRoot) {
187         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
188         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
189         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
190         // the merkle tree.
191         uint256 leavesLen = leaves.length;
192         uint256 totalHashes = proofFlags.length;
193 
194         // Check proof validity.
195         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
196 
197         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
198         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
199         bytes32[] memory hashes = new bytes32[](totalHashes);
200         uint256 leafPos = 0;
201         uint256 hashPos = 0;
202         uint256 proofPos = 0;
203         // At each step, we compute the next hash using two values:
204         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
205         //   get the next hash.
206         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
207         //   `proof` array.
208         for (uint256 i = 0; i < totalHashes; i++) {
209             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
210             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
211             hashes[i] = _hashPair(a, b);
212         }
213 
214         if (totalHashes > 0) {
215             return hashes[totalHashes - 1];
216         } else if (leavesLen > 0) {
217             return leaves[0];
218         } else {
219             return proof[0];
220         }
221     }
222 
223     /**
224      * @dev Calldata version of {processMultiProof}
225      *
226      * _Available since v4.7._
227      */
228     function processMultiProofCalldata(
229         bytes32[] calldata proof,
230         bool[] calldata proofFlags,
231         bytes32[] memory leaves
232     ) internal pure returns (bytes32 merkleRoot) {
233         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
234         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
235         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
236         // the merkle tree.
237         uint256 leavesLen = leaves.length;
238         uint256 totalHashes = proofFlags.length;
239 
240         // Check proof validity.
241         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
242 
243         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
244         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
245         bytes32[] memory hashes = new bytes32[](totalHashes);
246         uint256 leafPos = 0;
247         uint256 hashPos = 0;
248         uint256 proofPos = 0;
249         // At each step, we compute the next hash using two values:
250         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
251         //   get the next hash.
252         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
253         //   `proof` array.
254         for (uint256 i = 0; i < totalHashes; i++) {
255             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
256             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
257             hashes[i] = _hashPair(a, b);
258         }
259 
260         if (totalHashes > 0) {
261             return hashes[totalHashes - 1];
262         } else if (leavesLen > 0) {
263             return leaves[0];
264         } else {
265             return proof[0];
266         }
267     }
268 
269     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
270         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
271     }
272 
273     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
274         /// @solidity memory-safe-assembly
275         assembly {
276             mstore(0x00, a)
277             mstore(0x20, b)
278             value := keccak256(0x00, 0x40)
279         }
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
398 // ERC721A Contracts v4.2.2
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
418      * The caller cannot approve to their own address.
419      */
420     error ApproveToCaller();
421 
422     /**
423      * Cannot query the balance for the zero address.
424      */
425     error BalanceQueryForZeroAddress();
426 
427     /**
428      * Cannot mint to the zero address.
429      */
430     error MintToZeroAddress();
431 
432     /**
433      * The quantity of tokens minted must be more than zero.
434      */
435     error MintZeroQuantity();
436 
437     /**
438      * The token does not exist.
439      */
440     error OwnerQueryForNonexistentToken();
441 
442     /**
443      * The caller must own the token or be an approved operator.
444      */
445     error TransferCallerNotOwnerNorApproved();
446 
447     /**
448      * The token must be owned by `from`.
449      */
450     error TransferFromIncorrectOwner();
451 
452     /**
453      * Cannot safely transfer to a contract that does not implement the
454      * ERC721Receiver interface.
455      */
456     error TransferToNonERC721ReceiverImplementer();
457 
458     /**
459      * Cannot transfer to the zero address.
460      */
461     error TransferToZeroAddress();
462 
463     /**
464      * The token does not exist.
465      */
466     error URIQueryForNonexistentToken();
467 
468     /**
469      * The `quantity` minted with ERC2309 exceeds the safety limit.
470      */
471     error MintERC2309QuantityExceedsLimit();
472 
473     /**
474      * The `extraData` cannot be set on an unintialized ownership slot.
475      */
476     error OwnershipNotInitializedForExtraData();
477 
478     // =============================================================
479     //                            STRUCTS
480     // =============================================================
481 
482     struct TokenOwnership {
483         // The address of the owner.
484         address addr;
485         // Stores the start time of ownership with minimal overhead for tokenomics.
486         uint64 startTimestamp;
487         // Whether the token has been burned.
488         bool burned;
489         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
490         uint24 extraData;
491     }
492 
493     // =============================================================
494     //                         TOKEN COUNTERS
495     // =============================================================
496 
497     /**
498      * @dev Returns the total number of tokens in existence.
499      * Burned tokens will reduce the count.
500      * To get the total number of tokens minted, please see {_totalMinted}.
501      */
502     function totalSupply() external view returns (uint256);
503 
504     // =============================================================
505     //                            IERC165
506     // =============================================================
507 
508     /**
509      * @dev Returns true if this contract implements the interface defined by
510      * `interfaceId`. See the corresponding
511      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
512      * to learn more about how these ids are created.
513      *
514      * This function call must use less than 30000 gas.
515      */
516     function supportsInterface(bytes4 interfaceId) external view returns (bool);
517 
518     // =============================================================
519     //                            IERC721
520     // =============================================================
521 
522     /**
523      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
524      */
525     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
526 
527     /**
528      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
529      */
530     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
531 
532     /**
533      * @dev Emitted when `owner` enables or disables
534      * (`approved`) `operator` to manage all of its assets.
535      */
536     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
537 
538     /**
539      * @dev Returns the number of tokens in `owner`'s account.
540      */
541     function balanceOf(address owner) external view returns (uint256 balance);
542 
543     /**
544      * @dev Returns the owner of the `tokenId` token.
545      *
546      * Requirements:
547      *
548      * - `tokenId` must exist.
549      */
550     function ownerOf(uint256 tokenId) external view returns (address owner);
551 
552     /**
553      * @dev Safely transfers `tokenId` token from `from` to `to`,
554      * checking first that contract recipients are aware of the ERC721 protocol
555      * to prevent tokens from being forever locked.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `tokenId` token must exist and be owned by `from`.
562      * - If the caller is not `from`, it must be have been allowed to move
563      * this token by either {approve} or {setApprovalForAll}.
564      * - If `to` refers to a smart contract, it must implement
565      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
566      *
567      * Emits a {Transfer} event.
568      */
569     function safeTransferFrom(
570         address from,
571         address to,
572         uint256 tokenId,
573         bytes calldata data
574     ) external;
575 
576     /**
577      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
578      */
579     function safeTransferFrom(
580         address from,
581         address to,
582         uint256 tokenId
583     ) external;
584 
585     /**
586      * @dev Transfers `tokenId` from `from` to `to`.
587      *
588      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
589      * whenever possible.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must be owned by `from`.
596      * - If the caller is not `from`, it must be approved to move this token
597      * by either {approve} or {setApprovalForAll}.
598      *
599      * Emits a {Transfer} event.
600      */
601     function transferFrom(
602         address from,
603         address to,
604         uint256 tokenId
605     ) external;
606 
607     /**
608      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
609      * The approval is cleared when the token is transferred.
610      *
611      * Only a single account can be approved at a time, so approving the
612      * zero address clears previous approvals.
613      *
614      * Requirements:
615      *
616      * - The caller must own the token or be an approved operator.
617      * - `tokenId` must exist.
618      *
619      * Emits an {Approval} event.
620      */
621     function approve(address to, uint256 tokenId) external;
622 
623     /**
624      * @dev Approve or remove `operator` as an operator for the caller.
625      * Operators can call {transferFrom} or {safeTransferFrom}
626      * for any token owned by the caller.
627      *
628      * Requirements:
629      *
630      * - The `operator` cannot be the caller.
631      *
632      * Emits an {ApprovalForAll} event.
633      */
634     function setApprovalForAll(address operator, bool _approved) external;
635 
636     /**
637      * @dev Returns the account approved for `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function getApproved(uint256 tokenId) external view returns (address operator);
644 
645     /**
646      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
647      *
648      * See {setApprovalForAll}.
649      */
650     function isApprovedForAll(address owner, address operator) external view returns (bool);
651 
652     // =============================================================
653     //                        IERC721Metadata
654     // =============================================================
655 
656     /**
657      * @dev Returns the token collection name.
658      */
659     function name() external view returns (string memory);
660 
661     /**
662      * @dev Returns the token collection symbol.
663      */
664     function symbol() external view returns (string memory);
665 
666     /**
667      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
668      */
669     function tokenURI(uint256 tokenId) external view returns (string memory);
670 
671     // =============================================================
672     //                           IERC2309
673     // =============================================================
674 
675     /**
676      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
677      * (inclusive) is transferred from `from` to `to`, as defined in the
678      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
679      *
680      * See {_mintERC2309} for more details.
681      */
682     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
683 }
684 
685 // File: erc721a/contracts/ERC721A.sol
686 
687 
688 // ERC721A Contracts v4.2.2
689 // Creator: Chiru Labs
690 
691 pragma solidity ^0.8.4;
692 
693 
694 /**
695  * @dev Interface of ERC721 token receiver.
696  */
697 interface ERC721A__IERC721Receiver {
698     function onERC721Received(
699         address operator,
700         address from,
701         uint256 tokenId,
702         bytes calldata data
703     ) external returns (bytes4);
704 }
705 
706 /**
707  * @title ERC721A
708  *
709  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
710  * Non-Fungible Token Standard, including the Metadata extension.
711  * Optimized for lower gas during batch mints.
712  *
713  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
714  * starting from `_startTokenId()`.
715  *
716  * Assumptions:
717  *
718  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
719  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
720  */
721 contract ERC721A is IERC721A {
722     // Reference type for token approval.
723     struct TokenApprovalRef {
724         address value;
725     }
726 
727     // =============================================================
728     //                           CONSTANTS
729     // =============================================================
730 
731     // Mask of an entry in packed address data.
732     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
733 
734     // The bit position of `numberMinted` in packed address data.
735     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
736 
737     // The bit position of `numberBurned` in packed address data.
738     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
739 
740     // The bit position of `aux` in packed address data.
741     uint256 private constant _BITPOS_AUX = 192;
742 
743     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
744     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
745 
746     // The bit position of `startTimestamp` in packed ownership.
747     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
748 
749     // The bit mask of the `burned` bit in packed ownership.
750     uint256 private constant _BITMASK_BURNED = 1 << 224;
751 
752     // The bit position of the `nextInitialized` bit in packed ownership.
753     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
754 
755     // The bit mask of the `nextInitialized` bit in packed ownership.
756     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
757 
758     // The bit position of `extraData` in packed ownership.
759     uint256 private constant _BITPOS_EXTRA_DATA = 232;
760 
761     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
762     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
763 
764     // The mask of the lower 160 bits for addresses.
765     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
766 
767     // The maximum `quantity` that can be minted with {_mintERC2309}.
768     // This limit is to prevent overflows on the address data entries.
769     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
770     // is required to cause an overflow, which is unrealistic.
771     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
772 
773     // The `Transfer` event signature is given by:
774     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
775     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
776         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
777 
778     // =============================================================
779     //                            STORAGE
780     // =============================================================
781 
782     // The next token ID to be minted.
783     uint256 private _currentIndex;
784 
785     // The number of tokens burned.
786     uint256 private _burnCounter;
787 
788     // Token name
789     string private _name;
790 
791     // Token symbol
792     string private _symbol;
793 
794     // Mapping from token ID to ownership details
795     // An empty struct value does not necessarily mean the token is unowned.
796     // See {_packedOwnershipOf} implementation for details.
797     //
798     // Bits Layout:
799     // - [0..159]   `addr`
800     // - [160..223] `startTimestamp`
801     // - [224]      `burned`
802     // - [225]      `nextInitialized`
803     // - [232..255] `extraData`
804     mapping(uint256 => uint256) private _packedOwnerships;
805 
806     // Mapping owner address to address data.
807     //
808     // Bits Layout:
809     // - [0..63]    `balance`
810     // - [64..127]  `numberMinted`
811     // - [128..191] `numberBurned`
812     // - [192..255] `aux`
813     mapping(address => uint256) private _packedAddressData;
814 
815     // Mapping from token ID to approved address.
816     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
817 
818     // Mapping from owner to operator approvals
819     mapping(address => mapping(address => bool)) private _operatorApprovals;
820 
821     // =============================================================
822     //                          CONSTRUCTOR
823     // =============================================================
824 
825     constructor(string memory name_, string memory symbol_) {
826         _name = name_;
827         _symbol = symbol_;
828         _currentIndex = _startTokenId();
829     }
830 
831     // =============================================================
832     //                   TOKEN COUNTING OPERATIONS
833     // =============================================================
834 
835     /**
836      * @dev Returns the starting token ID.
837      * To change the starting token ID, please override this function.
838      */
839     function _startTokenId() internal view virtual returns (uint256) {
840         return 0;
841     }
842 
843     /**
844      * @dev Returns the next token ID to be minted.
845      */
846     function _nextTokenId() internal view virtual returns (uint256) {
847         return _currentIndex;
848     }
849 
850     /**
851      * @dev Returns the total number of tokens in existence.
852      * Burned tokens will reduce the count.
853      * To get the total number of tokens minted, please see {_totalMinted}.
854      */
855     function totalSupply() public view virtual override returns (uint256) {
856         // Counter underflow is impossible as _burnCounter cannot be incremented
857         // more than `_currentIndex - _startTokenId()` times.
858         unchecked {
859             return _currentIndex - _burnCounter - _startTokenId();
860         }
861     }
862 
863     /**
864      * @dev Returns the total amount of tokens minted in the contract.
865      */
866     function _totalMinted() internal view virtual returns (uint256) {
867         // Counter underflow is impossible as `_currentIndex` does not decrement,
868         // and it is initialized to `_startTokenId()`.
869         unchecked {
870             return _currentIndex - _startTokenId();
871         }
872     }
873 
874     /**
875      * @dev Returns the total number of tokens burned.
876      */
877     function _totalBurned() internal view virtual returns (uint256) {
878         return _burnCounter;
879     }
880 
881     // =============================================================
882     //                    ADDRESS DATA OPERATIONS
883     // =============================================================
884 
885     /**
886      * @dev Returns the number of tokens in `owner`'s account.
887      */
888     function balanceOf(address owner) public view virtual override returns (uint256) {
889         if (owner == address(0)) revert BalanceQueryForZeroAddress();
890         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
891     }
892 
893     /**
894      * Returns the number of tokens minted by `owner`.
895      */
896     function _numberMinted(address owner) internal view returns (uint256) {
897         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
898     }
899 
900     /**
901      * Returns the number of tokens burned by or on behalf of `owner`.
902      */
903     function _numberBurned(address owner) internal view returns (uint256) {
904         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
905     }
906 
907     /**
908      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
909      */
910     function _getAux(address owner) internal view returns (uint64) {
911         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
912     }
913 
914     /**
915      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
916      * If there are multiple variables, please pack them into a uint64.
917      */
918     function _setAux(address owner, uint64 aux) internal virtual {
919         uint256 packed = _packedAddressData[owner];
920         uint256 auxCasted;
921         // Cast `aux` with assembly to avoid redundant masking.
922         assembly {
923             auxCasted := aux
924         }
925         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
926         _packedAddressData[owner] = packed;
927     }
928 
929     // =============================================================
930     //                            IERC165
931     // =============================================================
932 
933     /**
934      * @dev Returns true if this contract implements the interface defined by
935      * `interfaceId`. See the corresponding
936      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
937      * to learn more about how these ids are created.
938      *
939      * This function call must use less than 30000 gas.
940      */
941     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
942         // The interface IDs are constants representing the first 4 bytes
943         // of the XOR of all function selectors in the interface.
944         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
945         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
946         return
947             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
948             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
949             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
950     }
951 
952     // =============================================================
953     //                        IERC721Metadata
954     // =============================================================
955 
956     /**
957      * @dev Returns the token collection name.
958      */
959     function name() public view virtual override returns (string memory) {
960         return _name;
961     }
962 
963     /**
964      * @dev Returns the token collection symbol.
965      */
966     function symbol() public view virtual override returns (string memory) {
967         return _symbol;
968     }
969 
970     /**
971      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
972      */
973     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
974         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
975 
976         string memory baseURI = _baseURI();
977         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
978     }
979 
980     /**
981      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
982      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
983      * by default, it can be overridden in child contracts.
984      */
985     function _baseURI() internal view virtual returns (string memory) {
986         return '';
987     }
988 
989     // =============================================================
990     //                     OWNERSHIPS OPERATIONS
991     // =============================================================
992 
993     /**
994      * @dev Returns the owner of the `tokenId` token.
995      *
996      * Requirements:
997      *
998      * - `tokenId` must exist.
999      */
1000     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1001         return address(uint160(_packedOwnershipOf(tokenId)));
1002     }
1003 
1004     /**
1005      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1006      * It gradually moves to O(1) as tokens get transferred around over time.
1007      */
1008     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1009         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1010     }
1011 
1012     /**
1013      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1014      */
1015     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1016         return _unpackedOwnership(_packedOwnerships[index]);
1017     }
1018 
1019     /**
1020      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1021      */
1022     function _initializeOwnershipAt(uint256 index) internal virtual {
1023         if (_packedOwnerships[index] == 0) {
1024             _packedOwnerships[index] = _packedOwnershipOf(index);
1025         }
1026     }
1027 
1028     /**
1029      * Returns the packed ownership data of `tokenId`.
1030      */
1031     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1032         uint256 curr = tokenId;
1033 
1034         unchecked {
1035             if (_startTokenId() <= curr)
1036                 if (curr < _currentIndex) {
1037                     uint256 packed = _packedOwnerships[curr];
1038                     // If not burned.
1039                     if (packed & _BITMASK_BURNED == 0) {
1040                         // Invariant:
1041                         // There will always be an initialized ownership slot
1042                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1043                         // before an unintialized ownership slot
1044                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1045                         // Hence, `curr` will not underflow.
1046                         //
1047                         // We can directly compare the packed value.
1048                         // If the address is zero, packed will be zero.
1049                         while (packed == 0) {
1050                             packed = _packedOwnerships[--curr];
1051                         }
1052                         return packed;
1053                     }
1054                 }
1055         }
1056         revert OwnerQueryForNonexistentToken();
1057     }
1058 
1059     /**
1060      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1061      */
1062     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1063         ownership.addr = address(uint160(packed));
1064         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1065         ownership.burned = packed & _BITMASK_BURNED != 0;
1066         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1067     }
1068 
1069     /**
1070      * @dev Packs ownership data into a single uint256.
1071      */
1072     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1073         assembly {
1074             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1075             owner := and(owner, _BITMASK_ADDRESS)
1076             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1077             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1078         }
1079     }
1080 
1081     /**
1082      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1083      */
1084     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1085         // For branchless setting of the `nextInitialized` flag.
1086         assembly {
1087             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1088             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1089         }
1090     }
1091 
1092     // =============================================================
1093     //                      APPROVAL OPERATIONS
1094     // =============================================================
1095 
1096     /**
1097      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1098      * The approval is cleared when the token is transferred.
1099      *
1100      * Only a single account can be approved at a time, so approving the
1101      * zero address clears previous approvals.
1102      *
1103      * Requirements:
1104      *
1105      * - The caller must own the token or be an approved operator.
1106      * - `tokenId` must exist.
1107      *
1108      * Emits an {Approval} event.
1109      */
1110     function approve(address to, uint256 tokenId) public virtual override {
1111         address owner = ownerOf(tokenId);
1112 
1113         if (_msgSenderERC721A() != owner)
1114             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1115                 revert ApprovalCallerNotOwnerNorApproved();
1116             }
1117 
1118         _tokenApprovals[tokenId].value = to;
1119         emit Approval(owner, to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev Returns the account approved for `tokenId` token.
1124      *
1125      * Requirements:
1126      *
1127      * - `tokenId` must exist.
1128      */
1129     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1130         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1131 
1132         return _tokenApprovals[tokenId].value;
1133     }
1134 
1135     /**
1136      * @dev Approve or remove `operator` as an operator for the caller.
1137      * Operators can call {transferFrom} or {safeTransferFrom}
1138      * for any token owned by the caller.
1139      *
1140      * Requirements:
1141      *
1142      * - The `operator` cannot be the caller.
1143      *
1144      * Emits an {ApprovalForAll} event.
1145      */
1146     function setApprovalForAll(address operator, bool approved) public virtual override {
1147         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1148 
1149         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1150         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1151     }
1152 
1153     /**
1154      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1155      *
1156      * See {setApprovalForAll}.
1157      */
1158     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1159         return _operatorApprovals[owner][operator];
1160     }
1161 
1162     /**
1163      * @dev Returns whether `tokenId` exists.
1164      *
1165      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1166      *
1167      * Tokens start existing when they are minted. See {_mint}.
1168      */
1169     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1170         return
1171             _startTokenId() <= tokenId &&
1172             tokenId < _currentIndex && // If within bounds,
1173             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1174     }
1175 
1176     /**
1177      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1178      */
1179     function _isSenderApprovedOrOwner(
1180         address approvedAddress,
1181         address owner,
1182         address msgSender
1183     ) private pure returns (bool result) {
1184         assembly {
1185             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1186             owner := and(owner, _BITMASK_ADDRESS)
1187             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1188             msgSender := and(msgSender, _BITMASK_ADDRESS)
1189             // `msgSender == owner || msgSender == approvedAddress`.
1190             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1191         }
1192     }
1193 
1194     /**
1195      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1196      */
1197     function _getApprovedSlotAndAddress(uint256 tokenId)
1198         private
1199         view
1200         returns (uint256 approvedAddressSlot, address approvedAddress)
1201     {
1202         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1203         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1204         assembly {
1205             approvedAddressSlot := tokenApproval.slot
1206             approvedAddress := sload(approvedAddressSlot)
1207         }
1208     }
1209 
1210     // =============================================================
1211     //                      TRANSFER OPERATIONS
1212     // =============================================================
1213 
1214     /**
1215      * @dev Transfers `tokenId` from `from` to `to`.
1216      *
1217      * Requirements:
1218      *
1219      * - `from` cannot be the zero address.
1220      * - `to` cannot be the zero address.
1221      * - `tokenId` token must be owned by `from`.
1222      * - If the caller is not `from`, it must be approved to move this token
1223      * by either {approve} or {setApprovalForAll}.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function transferFrom(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) public virtual override {
1232         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1233 
1234         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1235 
1236         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1237 
1238         // The nested ifs save around 20+ gas over a compound boolean condition.
1239         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1240             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1241 
1242         if (to == address(0)) revert TransferToZeroAddress();
1243 
1244         _beforeTokenTransfers(from, to, tokenId, 1);
1245 
1246         // Clear approvals from the previous owner.
1247         assembly {
1248             if approvedAddress {
1249                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1250                 sstore(approvedAddressSlot, 0)
1251             }
1252         }
1253 
1254         // Underflow of the sender's balance is impossible because we check for
1255         // ownership above and the recipient's balance can't realistically overflow.
1256         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1257         unchecked {
1258             // We can directly increment and decrement the balances.
1259             --_packedAddressData[from]; // Updates: `balance -= 1`.
1260             ++_packedAddressData[to]; // Updates: `balance += 1`.
1261 
1262             // Updates:
1263             // - `address` to the next owner.
1264             // - `startTimestamp` to the timestamp of transfering.
1265             // - `burned` to `false`.
1266             // - `nextInitialized` to `true`.
1267             _packedOwnerships[tokenId] = _packOwnershipData(
1268                 to,
1269                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1270             );
1271 
1272             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1273             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1274                 uint256 nextTokenId = tokenId + 1;
1275                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1276                 if (_packedOwnerships[nextTokenId] == 0) {
1277                     // If the next slot is within bounds.
1278                     if (nextTokenId != _currentIndex) {
1279                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1280                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1281                     }
1282                 }
1283             }
1284         }
1285 
1286         emit Transfer(from, to, tokenId);
1287         _afterTokenTransfers(from, to, tokenId, 1);
1288     }
1289 
1290     /**
1291      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1292      */
1293     function safeTransferFrom(
1294         address from,
1295         address to,
1296         uint256 tokenId
1297     ) public virtual override {
1298         safeTransferFrom(from, to, tokenId, '');
1299     }
1300 
1301     /**
1302      * @dev Safely transfers `tokenId` token from `from` to `to`.
1303      *
1304      * Requirements:
1305      *
1306      * - `from` cannot be the zero address.
1307      * - `to` cannot be the zero address.
1308      * - `tokenId` token must exist and be owned by `from`.
1309      * - If the caller is not `from`, it must be approved to move this token
1310      * by either {approve} or {setApprovalForAll}.
1311      * - If `to` refers to a smart contract, it must implement
1312      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function safeTransferFrom(
1317         address from,
1318         address to,
1319         uint256 tokenId,
1320         bytes memory _data
1321     ) public virtual override {
1322         transferFrom(from, to, tokenId);
1323         if (to.code.length != 0)
1324             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1325                 revert TransferToNonERC721ReceiverImplementer();
1326             }
1327     }
1328 
1329     /**
1330      * @dev Hook that is called before a set of serially-ordered token IDs
1331      * are about to be transferred. This includes minting.
1332      * And also called before burning one token.
1333      *
1334      * `startTokenId` - the first token ID to be transferred.
1335      * `quantity` - the amount to be transferred.
1336      *
1337      * Calling conditions:
1338      *
1339      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1340      * transferred to `to`.
1341      * - When `from` is zero, `tokenId` will be minted for `to`.
1342      * - When `to` is zero, `tokenId` will be burned by `from`.
1343      * - `from` and `to` are never both zero.
1344      */
1345     function _beforeTokenTransfers(
1346         address from,
1347         address to,
1348         uint256 startTokenId,
1349         uint256 quantity
1350     ) internal virtual {}
1351 
1352     /**
1353      * @dev Hook that is called after a set of serially-ordered token IDs
1354      * have been transferred. This includes minting.
1355      * And also called after one token has been burned.
1356      *
1357      * `startTokenId` - the first token ID to be transferred.
1358      * `quantity` - the amount to be transferred.
1359      *
1360      * Calling conditions:
1361      *
1362      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1363      * transferred to `to`.
1364      * - When `from` is zero, `tokenId` has been minted for `to`.
1365      * - When `to` is zero, `tokenId` has been burned by `from`.
1366      * - `from` and `to` are never both zero.
1367      */
1368     function _afterTokenTransfers(
1369         address from,
1370         address to,
1371         uint256 startTokenId,
1372         uint256 quantity
1373     ) internal virtual {}
1374 
1375     /**
1376      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1377      *
1378      * `from` - Previous owner of the given token ID.
1379      * `to` - Target address that will receive the token.
1380      * `tokenId` - Token ID to be transferred.
1381      * `_data` - Optional data to send along with the call.
1382      *
1383      * Returns whether the call correctly returned the expected magic value.
1384      */
1385     function _checkContractOnERC721Received(
1386         address from,
1387         address to,
1388         uint256 tokenId,
1389         bytes memory _data
1390     ) private returns (bool) {
1391         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1392             bytes4 retval
1393         ) {
1394             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1395         } catch (bytes memory reason) {
1396             if (reason.length == 0) {
1397                 revert TransferToNonERC721ReceiverImplementer();
1398             } else {
1399                 assembly {
1400                     revert(add(32, reason), mload(reason))
1401                 }
1402             }
1403         }
1404     }
1405 
1406     // =============================================================
1407     //                        MINT OPERATIONS
1408     // =============================================================
1409 
1410     /**
1411      * @dev Mints `quantity` tokens and transfers them to `to`.
1412      *
1413      * Requirements:
1414      *
1415      * - `to` cannot be the zero address.
1416      * - `quantity` must be greater than 0.
1417      *
1418      * Emits a {Transfer} event for each mint.
1419      */
1420     function _mint(address to, uint256 quantity) internal virtual {
1421         uint256 startTokenId = _currentIndex;
1422         if (quantity == 0) revert MintZeroQuantity();
1423 
1424         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1425 
1426         // Overflows are incredibly unrealistic.
1427         // `balance` and `numberMinted` have a maximum limit of 2**64.
1428         // `tokenId` has a maximum limit of 2**256.
1429         unchecked {
1430             // Updates:
1431             // - `balance += quantity`.
1432             // - `numberMinted += quantity`.
1433             //
1434             // We can directly add to the `balance` and `numberMinted`.
1435             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1436 
1437             // Updates:
1438             // - `address` to the owner.
1439             // - `startTimestamp` to the timestamp of minting.
1440             // - `burned` to `false`.
1441             // - `nextInitialized` to `quantity == 1`.
1442             _packedOwnerships[startTokenId] = _packOwnershipData(
1443                 to,
1444                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1445             );
1446 
1447             uint256 toMasked;
1448             uint256 end = startTokenId + quantity;
1449 
1450             // Use assembly to loop and emit the `Transfer` event for gas savings.
1451             assembly {
1452                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1453                 toMasked := and(to, _BITMASK_ADDRESS)
1454                 // Emit the `Transfer` event.
1455                 log4(
1456                     0, // Start of data (0, since no data).
1457                     0, // End of data (0, since no data).
1458                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1459                     0, // `address(0)`.
1460                     toMasked, // `to`.
1461                     startTokenId // `tokenId`.
1462                 )
1463 
1464                 for {
1465                     let tokenId := add(startTokenId, 1)
1466                 } iszero(eq(tokenId, end)) {
1467                     tokenId := add(tokenId, 1)
1468                 } {
1469                     // Emit the `Transfer` event. Similar to above.
1470                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1471                 }
1472             }
1473             if (toMasked == 0) revert MintToZeroAddress();
1474 
1475             _currentIndex = end;
1476         }
1477         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1478     }
1479 
1480     /**
1481      * @dev Mints `quantity` tokens and transfers them to `to`.
1482      *
1483      * This function is intended for efficient minting only during contract creation.
1484      *
1485      * It emits only one {ConsecutiveTransfer} as defined in
1486      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1487      * instead of a sequence of {Transfer} event(s).
1488      *
1489      * Calling this function outside of contract creation WILL make your contract
1490      * non-compliant with the ERC721 standard.
1491      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1492      * {ConsecutiveTransfer} event is only permissible during contract creation.
1493      *
1494      * Requirements:
1495      *
1496      * - `to` cannot be the zero address.
1497      * - `quantity` must be greater than 0.
1498      *
1499      * Emits a {ConsecutiveTransfer} event.
1500      */
1501     function _mintERC2309(address to, uint256 quantity) internal virtual {
1502         uint256 startTokenId = _currentIndex;
1503         if (to == address(0)) revert MintToZeroAddress();
1504         if (quantity == 0) revert MintZeroQuantity();
1505         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1506 
1507         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1508 
1509         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1510         unchecked {
1511             // Updates:
1512             // - `balance += quantity`.
1513             // - `numberMinted += quantity`.
1514             //
1515             // We can directly add to the `balance` and `numberMinted`.
1516             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1517 
1518             // Updates:
1519             // - `address` to the owner.
1520             // - `startTimestamp` to the timestamp of minting.
1521             // - `burned` to `false`.
1522             // - `nextInitialized` to `quantity == 1`.
1523             _packedOwnerships[startTokenId] = _packOwnershipData(
1524                 to,
1525                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1526             );
1527 
1528             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1529 
1530             _currentIndex = startTokenId + quantity;
1531         }
1532         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1533     }
1534 
1535     /**
1536      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1537      *
1538      * Requirements:
1539      *
1540      * - If `to` refers to a smart contract, it must implement
1541      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1542      * - `quantity` must be greater than 0.
1543      *
1544      * See {_mint}.
1545      *
1546      * Emits a {Transfer} event for each mint.
1547      */
1548     function _safeMint(
1549         address to,
1550         uint256 quantity,
1551         bytes memory _data
1552     ) internal virtual {
1553         _mint(to, quantity);
1554 
1555         unchecked {
1556             if (to.code.length != 0) {
1557                 uint256 end = _currentIndex;
1558                 uint256 index = end - quantity;
1559                 do {
1560                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1561                         revert TransferToNonERC721ReceiverImplementer();
1562                     }
1563                 } while (index < end);
1564                 // Reentrancy protection.
1565                 if (_currentIndex != end) revert();
1566             }
1567         }
1568     }
1569 
1570     /**
1571      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1572      */
1573     function _safeMint(address to, uint256 quantity) internal virtual {
1574         _safeMint(to, quantity, '');
1575     }
1576 
1577     // =============================================================
1578     //                        BURN OPERATIONS
1579     // =============================================================
1580 
1581     /**
1582      * @dev Equivalent to `_burn(tokenId, false)`.
1583      */
1584     function _burn(uint256 tokenId) internal virtual {
1585         _burn(tokenId, false);
1586     }
1587 
1588     /**
1589      * @dev Destroys `tokenId`.
1590      * The approval is cleared when the token is burned.
1591      *
1592      * Requirements:
1593      *
1594      * - `tokenId` must exist.
1595      *
1596      * Emits a {Transfer} event.
1597      */
1598     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1599         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1600 
1601         address from = address(uint160(prevOwnershipPacked));
1602 
1603         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1604 
1605         if (approvalCheck) {
1606             // The nested ifs save around 20+ gas over a compound boolean condition.
1607             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1608                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1609         }
1610 
1611         _beforeTokenTransfers(from, address(0), tokenId, 1);
1612 
1613         // Clear approvals from the previous owner.
1614         assembly {
1615             if approvedAddress {
1616                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1617                 sstore(approvedAddressSlot, 0)
1618             }
1619         }
1620 
1621         // Underflow of the sender's balance is impossible because we check for
1622         // ownership above and the recipient's balance can't realistically overflow.
1623         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1624         unchecked {
1625             // Updates:
1626             // - `balance -= 1`.
1627             // - `numberBurned += 1`.
1628             //
1629             // We can directly decrement the balance, and increment the number burned.
1630             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1631             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1632 
1633             // Updates:
1634             // - `address` to the last owner.
1635             // - `startTimestamp` to the timestamp of burning.
1636             // - `burned` to `true`.
1637             // - `nextInitialized` to `true`.
1638             _packedOwnerships[tokenId] = _packOwnershipData(
1639                 from,
1640                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1641             );
1642 
1643             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1644             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1645                 uint256 nextTokenId = tokenId + 1;
1646                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1647                 if (_packedOwnerships[nextTokenId] == 0) {
1648                     // If the next slot is within bounds.
1649                     if (nextTokenId != _currentIndex) {
1650                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1651                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1652                     }
1653                 }
1654             }
1655         }
1656 
1657         emit Transfer(from, address(0), tokenId);
1658         _afterTokenTransfers(from, address(0), tokenId, 1);
1659 
1660         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1661         unchecked {
1662             _burnCounter++;
1663         }
1664     }
1665 
1666     // =============================================================
1667     //                     EXTRA DATA OPERATIONS
1668     // =============================================================
1669 
1670     /**
1671      * @dev Directly sets the extra data for the ownership data `index`.
1672      */
1673     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1674         uint256 packed = _packedOwnerships[index];
1675         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1676         uint256 extraDataCasted;
1677         // Cast `extraData` with assembly to avoid redundant masking.
1678         assembly {
1679             extraDataCasted := extraData
1680         }
1681         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1682         _packedOwnerships[index] = packed;
1683     }
1684 
1685     /**
1686      * @dev Called during each token transfer to set the 24bit `extraData` field.
1687      * Intended to be overridden by the cosumer contract.
1688      *
1689      * `previousExtraData` - the value of `extraData` before transfer.
1690      *
1691      * Calling conditions:
1692      *
1693      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1694      * transferred to `to`.
1695      * - When `from` is zero, `tokenId` will be minted for `to`.
1696      * - When `to` is zero, `tokenId` will be burned by `from`.
1697      * - `from` and `to` are never both zero.
1698      */
1699     function _extraData(
1700         address from,
1701         address to,
1702         uint24 previousExtraData
1703     ) internal view virtual returns (uint24) {}
1704 
1705     /**
1706      * @dev Returns the next extra data for the packed ownership data.
1707      * The returned result is shifted into position.
1708      */
1709     function _nextExtraData(
1710         address from,
1711         address to,
1712         uint256 prevOwnershipPacked
1713     ) private view returns (uint256) {
1714         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1715         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1716     }
1717 
1718     // =============================================================
1719     //                       OTHER OPERATIONS
1720     // =============================================================
1721 
1722     /**
1723      * @dev Returns the message sender (defaults to `msg.sender`).
1724      *
1725      * If you are writing GSN compatible contracts, you need to override this function.
1726      */
1727     function _msgSenderERC721A() internal view virtual returns (address) {
1728         return msg.sender;
1729     }
1730 
1731     /**
1732      * @dev Converts a uint256 to its ASCII string decimal representation.
1733      */
1734     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1735         assembly {
1736             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1737             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1738             // We will need 1 32-byte word to store the length,
1739             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1740             str := add(mload(0x40), 0x80)
1741             // Update the free memory pointer to allocate.
1742             mstore(0x40, str)
1743 
1744             // Cache the end of the memory to calculate the length later.
1745             let end := str
1746 
1747             // We write the string from rightmost digit to leftmost digit.
1748             // The following is essentially a do-while loop that also handles the zero case.
1749             // prettier-ignore
1750             for { let temp := value } 1 {} {
1751                 str := sub(str, 1)
1752                 // Write the character to the pointer.
1753                 // The ASCII index of the '0' character is 48.
1754                 mstore8(str, add(48, mod(temp, 10)))
1755                 // Keep dividing `temp` until zero.
1756                 temp := div(temp, 10)
1757                 // prettier-ignore
1758                 if iszero(temp) { break }
1759             }
1760 
1761             let length := sub(end, str)
1762             // Move the pointer 32 bytes leftwards to make room for the length.
1763             str := sub(str, 0x20)
1764             // Store the length.
1765             mstore(str, length)
1766         }
1767     }
1768 }
1769 
1770 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1771 
1772 
1773 // ERC721A Contracts v4.2.3
1774 // Creator: Chiru Labs
1775 
1776 pragma solidity ^0.8.4;
1777 
1778 
1779 /**
1780  * @dev Interface of ERC721AQueryable.
1781  */
1782 interface IERC721AQueryable is IERC721A {
1783     /**
1784      * Invalid query range (`start` >= `stop`).
1785      */
1786     error InvalidQueryRange();
1787 
1788     /**
1789      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1790      *
1791      * If the `tokenId` is out of bounds:
1792      *
1793      * - `addr = address(0)`
1794      * - `startTimestamp = 0`
1795      * - `burned = false`
1796      * - `extraData = 0`
1797      *
1798      * If the `tokenId` is burned:
1799      *
1800      * - `addr = <Address of owner before token was burned>`
1801      * - `startTimestamp = <Timestamp when token was burned>`
1802      * - `burned = true`
1803      * - `extraData = <Extra data when token was burned>`
1804      *
1805      * Otherwise:
1806      *
1807      * - `addr = <Address of owner>`
1808      * - `startTimestamp = <Timestamp of start of ownership>`
1809      * - `burned = false`
1810      * - `extraData = <Extra data at start of ownership>`
1811      */
1812     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1813 
1814     /**
1815      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1816      * See {ERC721AQueryable-explicitOwnershipOf}
1817      */
1818     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1819 
1820     /**
1821      * @dev Returns an array of token IDs owned by `owner`,
1822      * in the range [`start`, `stop`)
1823      * (i.e. `start <= tokenId < stop`).
1824      *
1825      * This function allows for tokens to be queried if the collection
1826      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1827      *
1828      * Requirements:
1829      *
1830      * - `start < stop`
1831      */
1832     function tokensOfOwnerIn(
1833         address owner,
1834         uint256 start,
1835         uint256 stop
1836     ) external view returns (uint256[] memory);
1837 
1838     /**
1839      * @dev Returns an array of token IDs owned by `owner`.
1840      *
1841      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1842      * It is meant to be called off-chain.
1843      *
1844      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1845      * multiple smaller scans if the collection is large enough to cause
1846      * an out-of-gas error (10K collections should be fine).
1847      */
1848     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1849 }
1850 
1851 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1852 
1853 
1854 // ERC721A Contracts v4.2.3
1855 // Creator: Chiru Labs
1856 
1857 pragma solidity ^0.8.4;
1858 
1859 
1860 
1861 /**
1862  * @title ERC721AQueryable.
1863  *
1864  * @dev ERC721A subclass with convenience query functions.
1865  */
1866 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1867     /**
1868      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1869      *
1870      * If the `tokenId` is out of bounds:
1871      *
1872      * - `addr = address(0)`
1873      * - `startTimestamp = 0`
1874      * - `burned = false`
1875      * - `extraData = 0`
1876      *
1877      * If the `tokenId` is burned:
1878      *
1879      * - `addr = <Address of owner before token was burned>`
1880      * - `startTimestamp = <Timestamp when token was burned>`
1881      * - `burned = true`
1882      * - `extraData = <Extra data when token was burned>`
1883      *
1884      * Otherwise:
1885      *
1886      * - `addr = <Address of owner>`
1887      * - `startTimestamp = <Timestamp of start of ownership>`
1888      * - `burned = false`
1889      * - `extraData = <Extra data at start of ownership>`
1890      */
1891     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1892         TokenOwnership memory ownership;
1893         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1894             return ownership;
1895         }
1896         ownership = _ownershipAt(tokenId);
1897         if (ownership.burned) {
1898             return ownership;
1899         }
1900         return _ownershipOf(tokenId);
1901     }
1902 
1903     /**
1904      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1905      * See {ERC721AQueryable-explicitOwnershipOf}
1906      */
1907     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1908         external
1909         view
1910         virtual
1911         override
1912         returns (TokenOwnership[] memory)
1913     {
1914         unchecked {
1915             uint256 tokenIdsLength = tokenIds.length;
1916             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1917             for (uint256 i; i != tokenIdsLength; ++i) {
1918                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1919             }
1920             return ownerships;
1921         }
1922     }
1923 
1924     /**
1925      * @dev Returns an array of token IDs owned by `owner`,
1926      * in the range [`start`, `stop`)
1927      * (i.e. `start <= tokenId < stop`).
1928      *
1929      * This function allows for tokens to be queried if the collection
1930      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1931      *
1932      * Requirements:
1933      *
1934      * - `start < stop`
1935      */
1936     function tokensOfOwnerIn(
1937         address owner,
1938         uint256 start,
1939         uint256 stop
1940     ) external view virtual override returns (uint256[] memory) {
1941         unchecked {
1942             if (start >= stop) revert InvalidQueryRange();
1943             uint256 tokenIdsIdx;
1944             uint256 stopLimit = _nextTokenId();
1945             // Set `start = max(start, _startTokenId())`.
1946             if (start < _startTokenId()) {
1947                 start = _startTokenId();
1948             }
1949             // Set `stop = min(stop, stopLimit)`.
1950             if (stop > stopLimit) {
1951                 stop = stopLimit;
1952             }
1953             uint256 tokenIdsMaxLength = balanceOf(owner);
1954             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1955             // to cater for cases where `balanceOf(owner)` is too big.
1956             if (start < stop) {
1957                 uint256 rangeLength = stop - start;
1958                 if (rangeLength < tokenIdsMaxLength) {
1959                     tokenIdsMaxLength = rangeLength;
1960                 }
1961             } else {
1962                 tokenIdsMaxLength = 0;
1963             }
1964             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1965             if (tokenIdsMaxLength == 0) {
1966                 return tokenIds;
1967             }
1968             // We need to call `explicitOwnershipOf(start)`,
1969             // because the slot at `start` may not be initialized.
1970             TokenOwnership memory ownership = explicitOwnershipOf(start);
1971             address currOwnershipAddr;
1972             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1973             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1974             if (!ownership.burned) {
1975                 currOwnershipAddr = ownership.addr;
1976             }
1977             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1978                 ownership = _ownershipAt(i);
1979                 if (ownership.burned) {
1980                     continue;
1981                 }
1982                 if (ownership.addr != address(0)) {
1983                     currOwnershipAddr = ownership.addr;
1984                 }
1985                 if (currOwnershipAddr == owner) {
1986                     tokenIds[tokenIdsIdx++] = i;
1987                 }
1988             }
1989             // Downsize the array to fit.
1990             assembly {
1991                 mstore(tokenIds, tokenIdsIdx)
1992             }
1993             return tokenIds;
1994         }
1995     }
1996 
1997     /**
1998      * @dev Returns an array of token IDs owned by `owner`.
1999      *
2000      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2001      * It is meant to be called off-chain.
2002      *
2003      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2004      * multiple smaller scans if the collection is large enough to cause
2005      * an out-of-gas error (10K collections should be fine).
2006      */
2007     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2008         unchecked {
2009             uint256 tokenIdsIdx;
2010             address currOwnershipAddr;
2011             uint256 tokenIdsLength = balanceOf(owner);
2012             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2013             TokenOwnership memory ownership;
2014             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2015                 ownership = _ownershipAt(i);
2016                 if (ownership.burned) {
2017                     continue;
2018                 }
2019                 if (ownership.addr != address(0)) {
2020                     currOwnershipAddr = ownership.addr;
2021                 }
2022                 if (currOwnershipAddr == owner) {
2023                     tokenIds[tokenIdsIdx++] = i;
2024                 }
2025             }
2026             return tokenIds;
2027         }
2028     }
2029 }
2030 
2031 // File: contracts/TroublemakerClub.sol
2032 
2033 
2034 
2035 pragma solidity ^0.8.4;
2036 
2037 
2038 
2039 
2040 
2041 contract TroublemakerClub is ERC721AQueryable, Ownable, ReentrancyGuard {
2042   bytes32 public merkleRoot;
2043   bytes32 public holderMerkleRoot;
2044   mapping(address => bool) public listClaimed;
2045 
2046   string public uriPrefix = '';
2047   
2048   uint256 public cost = 0.003 ether;
2049   uint256 public maxSupply = 8888;
2050   uint256 public maxMintAmountPerTx = 5;
2051 
2052   bool public holderMintEnabled = false;
2053   bool public whitelistMintEnabled = false;
2054   bool public publicMintEnabled = false;
2055 
2056   IERC721A public MachineSoldier = IERC721A(address(0x856b5eFe21CF134924f40F0124631298bB2204f6));
2057 
2058   constructor(
2059     string memory _tokenName,
2060     string memory _tokenSymbol
2061   ) ERC721A(_tokenName, _tokenSymbol) {
2062     _safeMint(msg.sender, 128);
2063   }
2064 
2065   modifier mintCompliance(uint256 _mintAmount) {
2066     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
2067     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2068     _;
2069   }
2070 
2071   function holderMint(bytes32[] calldata _merkleProof) public {
2072     require(holderMintEnabled, 'The holder mint is not enabled!');
2073     require(!listClaimed[_msgSender()], 'Address already claimed!');
2074     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2075     require(MerkleProof.verify(_merkleProof, holderMerkleRoot, leaf), 'Invalid proof!');
2076 
2077     uint256 _mintAmount = 1;
2078     uint256 msCount = MachineSoldier.balanceOf(address(msg.sender));
2079     
2080     if (msCount >= 10) {
2081       uint256 multiplier = 10;
2082       _mintAmount += (msCount * multiplier) / 100;
2083     }
2084 
2085     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2086     listClaimed[_msgSender()] = true;
2087 
2088     _safeMint(_msgSender(), _mintAmount);
2089   }
2090 
2091   function whitelistMint(bytes32[] calldata _merkleProof) public {
2092     require(whitelistMintEnabled, 'The WL mint is not enabled!');
2093     require(!listClaimed[_msgSender()], 'Address already claimed!');
2094     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2095     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
2096     require(totalSupply() + 1 <= maxSupply, 'Max supply exceeded!');
2097 
2098     listClaimed[_msgSender()] = true;
2099     _safeMint(_msgSender(), 1);
2100   }
2101 
2102   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
2103     require(publicMintEnabled, 'The contract is paused!');
2104     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
2105     if (random(100) < _mintAmount) {
2106       _mintAmount += 1;
2107     }
2108 
2109     _safeMint(_msgSender(), _mintAmount);
2110   }
2111   
2112   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
2113     _safeMint(_receiver, _mintAmount);
2114   }
2115 
2116   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2117     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2118 
2119     string memory currentBaseURI = _baseURI();
2120     return bytes(currentBaseURI).length > 0
2121         ? string(abi.encodePacked(currentBaseURI, _toString(_tokenId)))
2122         : '';
2123   }
2124 
2125   function setCost(uint256 _cost) public onlyOwner {
2126     cost = _cost;
2127   }
2128 
2129   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2130     maxMintAmountPerTx = _maxMintAmountPerTx;
2131   }
2132 
2133   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2134     uriPrefix = _uriPrefix;
2135   }
2136 
2137   function setPublicMintEnabled(bool _state) public onlyOwner {
2138     publicMintEnabled = _state;
2139   }
2140 
2141   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2142     merkleRoot = _merkleRoot;
2143   }
2144 
2145   function setWhitelistMintEnabled(bool _state) public onlyOwner {
2146     whitelistMintEnabled = _state;
2147   }
2148 
2149   function setHolderMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2150     holderMerkleRoot = _merkleRoot;
2151   }
2152 
2153   function setHolderMintEnabled(bool _state) public onlyOwner {
2154     holderMintEnabled = _state;
2155   }
2156 
2157   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2158     maxSupply = _maxSupply;
2159   }
2160 
2161   function withdraw() public onlyOwner nonReentrant {
2162     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2163     require(os);
2164   }
2165 
2166   function _baseURI() internal view virtual override returns (string memory) {
2167     return uriPrefix;
2168   }
2169 
2170   function random(uint number) internal view returns(uint) {
2171     return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % number;
2172   }
2173 }