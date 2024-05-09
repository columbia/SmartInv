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
216 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Contract module that helps prevent reentrant calls to a function.
225  *
226  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
227  * available, which can be applied to functions to make sure there are no nested
228  * (reentrant) calls to them.
229  *
230  * Note that because there is a single `nonReentrant` guard, functions marked as
231  * `nonReentrant` may not call one another. This can be worked around by making
232  * those functions `private`, and then adding `external` `nonReentrant` entry
233  * points to them.
234  *
235  * TIP: If you would like to learn more about reentrancy and alternative ways
236  * to protect against it, check out our blog post
237  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
238  */
239 abstract contract ReentrancyGuard {
240     // Booleans are more expensive than uint256 or any type that takes up a full
241     // word because each write operation emits an extra SLOAD to first read the
242     // slot's contents, replace the bits taken up by the boolean, and then write
243     // back. This is the compiler's defense against contract upgrades and
244     // pointer aliasing, and it cannot be disabled.
245 
246     // The values being non-zero value makes deployment a bit more expensive,
247     // but in exchange the refund on every call to nonReentrant will be lower in
248     // amount. Since refunds are capped to a percentage of the total
249     // transaction's gas, it is best to keep them low in cases like this one, to
250     // increase the likelihood of the full refund coming into effect.
251     uint256 private constant _NOT_ENTERED = 1;
252     uint256 private constant _ENTERED = 2;
253 
254     uint256 private _status;
255 
256     constructor() {
257         _status = _NOT_ENTERED;
258     }
259 
260     /**
261      * @dev Prevents a contract from calling itself, directly or indirectly.
262      * Calling a `nonReentrant` function from another `nonReentrant`
263      * function is not supported. It is possible to prevent this from happening
264      * by making the `nonReentrant` function external, and making it call a
265      * `private` function that does the actual work.
266      */
267     modifier nonReentrant() {
268         // On the first call to nonReentrant, _notEntered will be true
269         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
270 
271         // Any calls to nonReentrant after this point will fail
272         _status = _ENTERED;
273 
274         _;
275 
276         // By storing the original value once again, a refund is triggered (see
277         // https://eips.ethereum.org/EIPS/eip-2200)
278         _status = _NOT_ENTERED;
279     }
280 }
281 
282 // File: @openzeppelin/contracts/utils/Context.sol
283 
284 
285 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @dev Provides information about the current execution context, including the
291  * sender of the transaction and its data. While these are generally available
292  * via msg.sender and msg.data, they should not be accessed in such a direct
293  * manner, since when dealing with meta-transactions the account sending and
294  * paying for execution may not be the actual sender (as far as an application
295  * is concerned).
296  *
297  * This contract is only required for intermediate, library-like contracts.
298  */
299 abstract contract Context {
300     function _msgSender() internal view virtual returns (address) {
301         return msg.sender;
302     }
303 
304     function _msgData() internal view virtual returns (bytes calldata) {
305         return msg.data;
306     }
307 }
308 
309 // File: @openzeppelin/contracts/access/Ownable.sol
310 
311 
312 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 
317 /**
318  * @dev Contract module which provides a basic access control mechanism, where
319  * there is an account (an owner) that can be granted exclusive access to
320  * specific functions.
321  *
322  * By default, the owner account will be the one that deploys the contract. This
323  * can later be changed with {transferOwnership}.
324  *
325  * This module is used through inheritance. It will make available the modifier
326  * `onlyOwner`, which can be applied to your functions to restrict their use to
327  * the owner.
328  */
329 abstract contract Ownable is Context {
330     address private _owner;
331 
332     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
333 
334     /**
335      * @dev Initializes the contract setting the deployer as the initial owner.
336      */
337     constructor() {
338         _transferOwnership(_msgSender());
339     }
340 
341     /**
342      * @dev Throws if called by any account other than the owner.
343      */
344     modifier onlyOwner() {
345         _checkOwner();
346         _;
347     }
348 
349     /**
350      * @dev Returns the address of the current owner.
351      */
352     function owner() public view virtual returns (address) {
353         return _owner;
354     }
355 
356     /**
357      * @dev Throws if the sender is not the owner.
358      */
359     function _checkOwner() internal view virtual {
360         require(owner() == _msgSender(), "Ownable: caller is not the owner");
361     }
362 
363     /**
364      * @dev Leaves the contract without owner. It will not be possible to call
365      * `onlyOwner` functions anymore. Can only be called by the current owner.
366      *
367      * NOTE: Renouncing ownership will leave the contract without an owner,
368      * thereby removing any functionality that is only available to the owner.
369      */
370     function renounceOwnership() public virtual onlyOwner {
371         _transferOwnership(address(0));
372     }
373 
374     /**
375      * @dev Transfers ownership of the contract to a new account (`newOwner`).
376      * Can only be called by the current owner.
377      */
378     function transferOwnership(address newOwner) public virtual onlyOwner {
379         require(newOwner != address(0), "Ownable: new owner is the zero address");
380         _transferOwnership(newOwner);
381     }
382 
383     /**
384      * @dev Transfers ownership of the contract to a new account (`newOwner`).
385      * Internal function without access restriction.
386      */
387     function _transferOwnership(address newOwner) internal virtual {
388         address oldOwner = _owner;
389         _owner = newOwner;
390         emit OwnershipTransferred(oldOwner, newOwner);
391     }
392 }
393 
394 // File: IERC721A.sol
395 
396 
397 // ERC721A Contracts v4.2.2
398 // Creator: Chiru Labs
399 
400 pragma solidity ^0.8.4;
401 
402 /**
403  * @dev Interface of ERC721A.
404  */
405 interface IERC721A {
406     /**
407      * The caller must own the token or be an approved operator.
408      */
409     error ApprovalCallerNotOwnerNorApproved();
410 
411     /**
412      * The token does not exist.
413      */
414     error ApprovalQueryForNonexistentToken();
415 
416     /**
417      * The caller cannot approve to their own address.
418      */
419     error ApproveToCaller();
420 
421     /**
422      * Cannot query the balance for the zero address.
423      */
424     error BalanceQueryForZeroAddress();
425 
426     /**
427      * Cannot mint to the zero address.
428      */
429     error MintToZeroAddress();
430 
431     /**
432      * The quantity of tokens minted must be more than zero.
433      */
434     error MintZeroQuantity();
435 
436     /**
437      * The token does not exist.
438      */
439     error OwnerQueryForNonexistentToken();
440 
441     /**
442      * The caller must own the token or be an approved operator.
443      */
444     error TransferCallerNotOwnerNorApproved();
445 
446     /**
447      * The token must be owned by `from`.
448      */
449     error TransferFromIncorrectOwner();
450 
451     /**
452      * Cannot safely transfer to a contract that does not implement the
453      * ERC721Receiver interface.
454      */
455     error TransferToNonERC721ReceiverImplementer();
456 
457     /**
458      * Cannot transfer to the zero address.
459      */
460     error TransferToZeroAddress();
461 
462     /**
463      * The token does not exist.
464      */
465     error URIQueryForNonexistentToken();
466 
467     /**
468      * The `quantity` minted with ERC2309 exceeds the safety limit.
469      */
470     error MintERC2309QuantityExceedsLimit();
471 
472     /**
473      * The `extraData` cannot be set on an unintialized ownership slot.
474      */
475     error OwnershipNotInitializedForExtraData();
476 
477     // =============================================================
478     //                            STRUCTS
479     // =============================================================
480 
481     struct TokenOwnership {
482         // The address of the owner.
483         address addr;
484         // Stores the start time of ownership with minimal overhead for tokenomics.
485         uint64 startTimestamp;
486         // Whether the token has been burned.
487         bool burned;
488         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
489         uint24 extraData;
490     }
491 
492     // =============================================================
493     //                         TOKEN COUNTERS
494     // =============================================================
495 
496     /**
497      * @dev Returns the total number of tokens in existence.
498      * Burned tokens will reduce the count.
499      * To get the total number of tokens minted, please see {_totalMinted}.
500      */
501     function totalSupply() external view returns (uint256);
502 
503     // =============================================================
504     //                            IERC165
505     // =============================================================
506 
507     /**
508      * @dev Returns true if this contract implements the interface defined by
509      * `interfaceId`. See the corresponding
510      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
511      * to learn more about how these ids are created.
512      *
513      * This function call must use less than 30000 gas.
514      */
515     function supportsInterface(bytes4 interfaceId) external view returns (bool);
516 
517     // =============================================================
518     //                            IERC721
519     // =============================================================
520 
521     /**
522      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
523      */
524     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
525 
526     /**
527      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
528      */
529     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
530 
531     /**
532      * @dev Emitted when `owner` enables or disables
533      * (`approved`) `operator` to manage all of its assets.
534      */
535     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
536 
537     /**
538      * @dev Returns the number of tokens in `owner`'s account.
539      */
540     function balanceOf(address owner) external view returns (uint256 balance);
541 
542     /**
543      * @dev Returns the owner of the `tokenId` token.
544      *
545      * Requirements:
546      *
547      * - `tokenId` must exist.
548      */
549     function ownerOf(uint256 tokenId) external view returns (address owner);
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`,
553      * checking first that contract recipients are aware of the ERC721 protocol
554      * to prevent tokens from being forever locked.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be have been allowed to move
562      * this token by either {approve} or {setApprovalForAll}.
563      * - If `to` refers to a smart contract, it must implement
564      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
565      *
566      * Emits a {Transfer} event.
567      */
568     function safeTransferFrom(
569         address from,
570         address to,
571         uint256 tokenId,
572         bytes calldata data
573     ) external;
574 
575     /**
576      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
577      */
578     function safeTransferFrom(
579         address from,
580         address to,
581         uint256 tokenId
582     ) external;
583 
584     /**
585      * @dev Transfers `tokenId` from `from` to `to`.
586      *
587      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
588      * whenever possible.
589      *
590      * Requirements:
591      *
592      * - `from` cannot be the zero address.
593      * - `to` cannot be the zero address.
594      * - `tokenId` token must be owned by `from`.
595      * - If the caller is not `from`, it must be approved to move this token
596      * by either {approve} or {setApprovalForAll}.
597      *
598      * Emits a {Transfer} event.
599      */
600     function transferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) external;
605 
606     /**
607      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
608      * The approval is cleared when the token is transferred.
609      *
610      * Only a single account can be approved at a time, so approving the
611      * zero address clears previous approvals.
612      *
613      * Requirements:
614      *
615      * - The caller must own the token or be an approved operator.
616      * - `tokenId` must exist.
617      *
618      * Emits an {Approval} event.
619      */
620     function approve(address to, uint256 tokenId) external;
621 
622     /**
623      * @dev Approve or remove `operator` as an operator for the caller.
624      * Operators can call {transferFrom} or {safeTransferFrom}
625      * for any token owned by the caller.
626      *
627      * Requirements:
628      *
629      * - The `operator` cannot be the caller.
630      *
631      * Emits an {ApprovalForAll} event.
632      */
633     function setApprovalForAll(address operator, bool _approved) external;
634 
635     /**
636      * @dev Returns the account approved for `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function getApproved(uint256 tokenId) external view returns (address operator);
643 
644     /**
645      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
646      *
647      * See {setApprovalForAll}.
648      */
649     function isApprovedForAll(address owner, address operator) external view returns (bool);
650 
651     // =============================================================
652     //                        IERC721Metadata
653     // =============================================================
654 
655     /**
656      * @dev Returns the token collection name.
657      */
658     function name() external view returns (string memory);
659 
660     /**
661      * @dev Returns the token collection symbol.
662      */
663     function symbol() external view returns (string memory);
664 
665     /**
666      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
667      */
668     function tokenURI(uint256 tokenId) external view returns (string memory);
669 
670     // =============================================================
671     //                           IERC2309
672     // =============================================================
673 
674     /**
675      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
676      * (inclusive) is transferred from `from` to `to`, as defined in the
677      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
678      *
679      * See {_mintERC2309} for more details.
680      */
681     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
682 }
683 // File: ERC721A.sol
684 
685 
686 // ERC721A Contracts v4.2.2
687 // Creator: Chiru Labs
688 
689 pragma solidity ^0.8.4;
690 
691 
692 /**
693  * @dev Interface of ERC721 token receiver.
694  */
695 interface ERC721A__IERC721Receiver {
696     function onERC721Received(
697         address operator,
698         address from,
699         uint256 tokenId,
700         bytes calldata data
701     ) external returns (bytes4);
702 }
703 
704 /**
705  * @title ERC721A
706  *
707  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
708  * Non-Fungible Token Standard, including the Metadata extension.
709  * Optimized for lower gas during batch mints.
710  *
711  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
712  * starting from `_startTokenId()`.
713  *
714  * Assumptions:
715  *
716  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
717  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
718  */
719 contract ERC721A is IERC721A {
720     // Reference type for token approval.
721     struct TokenApprovalRef {
722         address value;
723     }
724 
725     // =============================================================
726     //                           CONSTANTS
727     // =============================================================
728 
729     // Mask of an entry in packed address data.
730     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
731 
732     // The bit position of `numberMinted` in packed address data.
733     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
734 
735     // The bit position of `numberBurned` in packed address data.
736     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
737 
738     // The bit position of `aux` in packed address data.
739     uint256 private constant _BITPOS_AUX = 192;
740 
741     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
742     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
743 
744     // The bit position of `startTimestamp` in packed ownership.
745     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
746 
747     // The bit mask of the `burned` bit in packed ownership.
748     uint256 private constant _BITMASK_BURNED = 1 << 224;
749 
750     // The bit position of the `nextInitialized` bit in packed ownership.
751     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
752 
753     // The bit mask of the `nextInitialized` bit in packed ownership.
754     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
755 
756     // The bit position of `extraData` in packed ownership.
757     uint256 private constant _BITPOS_EXTRA_DATA = 232;
758 
759     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
760     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
761 
762     // The mask of the lower 160 bits for addresses.
763     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
764 
765     // The maximum `quantity` that can be minted with {_mintERC2309}.
766     // This limit is to prevent overflows on the address data entries.
767     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
768     // is required to cause an overflow, which is unrealistic.
769     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
770 
771     // The `Transfer` event signature is given by:
772     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
773     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
774         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
775 
776     // =============================================================
777     //                            STORAGE
778     // =============================================================
779 
780     // The next token ID to be minted.
781     uint256 private _currentIndex;
782 
783     // The number of tokens burned.
784     uint256 private _burnCounter;
785 
786     // Token name
787     string private _name;
788 
789     // Token symbol
790     string private _symbol;
791 
792     // Mapping from token ID to ownership details
793     // An empty struct value does not necessarily mean the token is unowned.
794     // See {_packedOwnershipOf} implementation for details.
795     //
796     // Bits Layout:
797     // - [0..159]   `addr`
798     // - [160..223] `startTimestamp`
799     // - [224]      `burned`
800     // - [225]      `nextInitialized`
801     // - [232..255] `extraData`
802     mapping(uint256 => uint256) private _packedOwnerships;
803 
804     // Mapping owner address to address data.
805     //
806     // Bits Layout:
807     // - [0..63]    `balance`
808     // - [64..127]  `numberMinted`
809     // - [128..191] `numberBurned`
810     // - [192..255] `aux`
811     mapping(address => uint256) private _packedAddressData;
812 
813     // Mapping from token ID to approved address.
814     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
815 
816     // Mapping from owner to operator approvals
817     mapping(address => mapping(address => bool)) private _operatorApprovals;
818 
819     // =============================================================
820     //                          CONSTRUCTOR
821     // =============================================================
822 
823     constructor(string memory name_, string memory symbol_) {
824         _name = name_;
825         _symbol = symbol_;
826         _currentIndex = _startTokenId();
827     }
828 
829     // =============================================================
830     //                   TOKEN COUNTING OPERATIONS
831     // =============================================================
832 
833     /**
834      * @dev Returns the starting token ID.
835      * To change the starting token ID, please override this function.
836      */
837     function _startTokenId() internal view virtual returns (uint256) {
838         return 0;
839     }
840 
841     /**
842      * @dev Returns the next token ID to be minted.
843      */
844     function _nextTokenId() internal view virtual returns (uint256) {
845         return _currentIndex;
846     }
847 
848     /**
849      * @dev Returns the total number of tokens in existence.
850      * Burned tokens will reduce the count.
851      * To get the total number of tokens minted, please see {_totalMinted}.
852      */
853     function totalSupply() public view virtual override returns (uint256) {
854         // Counter underflow is impossible as _burnCounter cannot be incremented
855         // more than `_currentIndex - _startTokenId()` times.
856         unchecked {
857             return _currentIndex - _burnCounter - _startTokenId();
858         }
859     }
860 
861     /**
862      * @dev Returns the total amount of tokens minted in the contract.
863      */
864     function _totalMinted() internal view virtual returns (uint256) {
865         // Counter underflow is impossible as `_currentIndex` does not decrement,
866         // and it is initialized to `_startTokenId()`.
867         unchecked {
868             return _currentIndex - _startTokenId();
869         }
870     }
871 
872     /**
873      * @dev Returns the total number of tokens burned.
874      */
875     function _totalBurned() internal view virtual returns (uint256) {
876         return _burnCounter;
877     }
878 
879     // =============================================================
880     //                    ADDRESS DATA OPERATIONS
881     // =============================================================
882 
883     /**
884      * @dev Returns the number of tokens in `owner`'s account.
885      */
886     function balanceOf(address owner) public view virtual override returns (uint256) {
887         if (owner == address(0)) revert BalanceQueryForZeroAddress();
888         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
889     }
890 
891     /**
892      * Returns the number of tokens minted by `owner`.
893      */
894     function _numberMinted(address owner) internal view returns (uint256) {
895         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
896     }
897 
898     /**
899      * Returns the number of tokens burned by or on behalf of `owner`.
900      */
901     function _numberBurned(address owner) internal view returns (uint256) {
902         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
903     }
904 
905     /**
906      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
907      */
908     function _getAux(address owner) internal view returns (uint64) {
909         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
910     }
911 
912     /**
913      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
914      * If there are multiple variables, please pack them into a uint64.
915      */
916     function _setAux(address owner, uint64 aux) internal virtual {
917         uint256 packed = _packedAddressData[owner];
918         uint256 auxCasted;
919         // Cast `aux` with assembly to avoid redundant masking.
920         assembly {
921             auxCasted := aux
922         }
923         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
924         _packedAddressData[owner] = packed;
925     }
926 
927     // =============================================================
928     //                            IERC165
929     // =============================================================
930 
931     /**
932      * @dev Returns true if this contract implements the interface defined by
933      * `interfaceId`. See the corresponding
934      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
935      * to learn more about how these ids are created.
936      *
937      * This function call must use less than 30000 gas.
938      */
939     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
940         // The interface IDs are constants representing the first 4 bytes
941         // of the XOR of all function selectors in the interface.
942         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
943         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
944         return
945             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
946             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
947             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
948     }
949 
950     // =============================================================
951     //                        IERC721Metadata
952     // =============================================================
953 
954     /**
955      * @dev Returns the token collection name.
956      */
957     function name() public view virtual override returns (string memory) {
958         return _name;
959     }
960 
961     /**
962      * @dev Returns the token collection symbol.
963      */
964     function symbol() public view virtual override returns (string memory) {
965         return _symbol;
966     }
967 
968     /**
969      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
970      */
971     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
972         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
973 
974         string memory baseURI = _baseURI();
975         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
976     }
977 
978     /**
979      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
980      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
981      * by default, it can be overridden in child contracts.
982      */
983     function _baseURI() internal view virtual returns (string memory) {
984         return '';
985     }
986 
987     // =============================================================
988     //                     OWNERSHIPS OPERATIONS
989     // =============================================================
990 
991     /**
992      * @dev Returns the owner of the `tokenId` token.
993      *
994      * Requirements:
995      *
996      * - `tokenId` must exist.
997      */
998     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
999         return address(uint160(_packedOwnershipOf(tokenId)));
1000     }
1001 
1002     /**
1003      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1004      * It gradually moves to O(1) as tokens get transferred around over time.
1005      */
1006     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1007         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1008     }
1009 
1010     /**
1011      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1012      */
1013     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1014         return _unpackedOwnership(_packedOwnerships[index]);
1015     }
1016 
1017     /**
1018      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1019      */
1020     function _initializeOwnershipAt(uint256 index) internal virtual {
1021         if (_packedOwnerships[index] == 0) {
1022             _packedOwnerships[index] = _packedOwnershipOf(index);
1023         }
1024     }
1025 
1026     /**
1027      * Returns the packed ownership data of `tokenId`.
1028      */
1029     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1030         uint256 curr = tokenId;
1031 
1032         unchecked {
1033             if (_startTokenId() <= curr)
1034                 if (curr < _currentIndex) {
1035                     uint256 packed = _packedOwnerships[curr];
1036                     // If not burned.
1037                     if (packed & _BITMASK_BURNED == 0) {
1038                         // Invariant:
1039                         // There will always be an initialized ownership slot
1040                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1041                         // before an unintialized ownership slot
1042                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1043                         // Hence, `curr` will not underflow.
1044                         //
1045                         // We can directly compare the packed value.
1046                         // If the address is zero, packed will be zero.
1047                         while (packed == 0) {
1048                             packed = _packedOwnerships[--curr];
1049                         }
1050                         return packed;
1051                     }
1052                 }
1053         }
1054         revert OwnerQueryForNonexistentToken();
1055     }
1056 
1057     /**
1058      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1059      */
1060     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1061         ownership.addr = address(uint160(packed));
1062         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1063         ownership.burned = packed & _BITMASK_BURNED != 0;
1064         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1065     }
1066 
1067     /**
1068      * @dev Packs ownership data into a single uint256.
1069      */
1070     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1071         assembly {
1072             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1073             owner := and(owner, _BITMASK_ADDRESS)
1074             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1075             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1076         }
1077     }
1078 
1079     /**
1080      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1081      */
1082     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1083         // For branchless setting of the `nextInitialized` flag.
1084         assembly {
1085             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1086             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1087         }
1088     }
1089 
1090     // =============================================================
1091     //                      APPROVAL OPERATIONS
1092     // =============================================================
1093 
1094     /**
1095      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1096      * The approval is cleared when the token is transferred.
1097      *
1098      * Only a single account can be approved at a time, so approving the
1099      * zero address clears previous approvals.
1100      *
1101      * Requirements:
1102      *
1103      * - The caller must own the token or be an approved operator.
1104      * - `tokenId` must exist.
1105      *
1106      * Emits an {Approval} event.
1107      */
1108     function approve(address to, uint256 tokenId) public virtual override {
1109         address owner = ownerOf(tokenId);
1110 
1111         if (_msgSenderERC721A() != owner)
1112             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1113                 revert ApprovalCallerNotOwnerNorApproved();
1114             }
1115 
1116         _tokenApprovals[tokenId].value = to;
1117         emit Approval(owner, to, tokenId);
1118     }
1119 
1120     /**
1121      * @dev Returns the account approved for `tokenId` token.
1122      *
1123      * Requirements:
1124      *
1125      * - `tokenId` must exist.
1126      */
1127     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1128         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1129 
1130         return _tokenApprovals[tokenId].value;
1131     }
1132 
1133     /**
1134      * @dev Approve or remove `operator` as an operator for the caller.
1135      * Operators can call {transferFrom} or {safeTransferFrom}
1136      * for any token owned by the caller.
1137      *
1138      * Requirements:
1139      *
1140      * - The `operator` cannot be the caller.
1141      *
1142      * Emits an {ApprovalForAll} event.
1143      */
1144     function setApprovalForAll(address operator, bool approved) public virtual override {
1145         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1146 
1147         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1148         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1149     }
1150 
1151     /**
1152      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1153      *
1154      * See {setApprovalForAll}.
1155      */
1156     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1157         return _operatorApprovals[owner][operator];
1158     }
1159 
1160     /**
1161      * @dev Returns whether `tokenId` exists.
1162      *
1163      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1164      *
1165      * Tokens start existing when they are minted. See {_mint}.
1166      */
1167     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1168         return
1169             _startTokenId() <= tokenId &&
1170             tokenId < _currentIndex && // If within bounds,
1171             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1172     }
1173 
1174     /**
1175      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1176      */
1177     function _isSenderApprovedOrOwner(
1178         address approvedAddress,
1179         address owner,
1180         address msgSender
1181     ) private pure returns (bool result) {
1182         assembly {
1183             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1184             owner := and(owner, _BITMASK_ADDRESS)
1185             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1186             msgSender := and(msgSender, _BITMASK_ADDRESS)
1187             // `msgSender == owner || msgSender == approvedAddress`.
1188             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1189         }
1190     }
1191 
1192     /**
1193      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1194      */
1195     function _getApprovedSlotAndAddress(uint256 tokenId)
1196         private
1197         view
1198         returns (uint256 approvedAddressSlot, address approvedAddress)
1199     {
1200         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1201         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1202         assembly {
1203             approvedAddressSlot := tokenApproval.slot
1204             approvedAddress := sload(approvedAddressSlot)
1205         }
1206     }
1207 
1208     // =============================================================
1209     //                      TRANSFER OPERATIONS
1210     // =============================================================
1211 
1212     /**
1213      * @dev Transfers `tokenId` from `from` to `to`.
1214      *
1215      * Requirements:
1216      *
1217      * - `from` cannot be the zero address.
1218      * - `to` cannot be the zero address.
1219      * - `tokenId` token must be owned by `from`.
1220      * - If the caller is not `from`, it must be approved to move this token
1221      * by either {approve} or {setApprovalForAll}.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function transferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) public virtual override {
1230         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1231 
1232         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1233 
1234         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1235 
1236         // The nested ifs save around 20+ gas over a compound boolean condition.
1237         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1238             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1239 
1240         if (to == address(0)) revert TransferToZeroAddress();
1241 
1242         _beforeTokenTransfers(from, to, tokenId, 1);
1243 
1244         // Clear approvals from the previous owner.
1245         assembly {
1246             if approvedAddress {
1247                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1248                 sstore(approvedAddressSlot, 0)
1249             }
1250         }
1251 
1252         // Underflow of the sender's balance is impossible because we check for
1253         // ownership above and the recipient's balance can't realistically overflow.
1254         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1255         unchecked {
1256             // We can directly increment and decrement the balances.
1257             --_packedAddressData[from]; // Updates: `balance -= 1`.
1258             ++_packedAddressData[to]; // Updates: `balance += 1`.
1259 
1260             // Updates:
1261             // - `address` to the next owner.
1262             // - `startTimestamp` to the timestamp of transfering.
1263             // - `burned` to `false`.
1264             // - `nextInitialized` to `true`.
1265             _packedOwnerships[tokenId] = _packOwnershipData(
1266                 to,
1267                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1268             );
1269 
1270             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1271             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1272                 uint256 nextTokenId = tokenId + 1;
1273                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1274                 if (_packedOwnerships[nextTokenId] == 0) {
1275                     // If the next slot is within bounds.
1276                     if (nextTokenId != _currentIndex) {
1277                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1278                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1279                     }
1280                 }
1281             }
1282         }
1283 
1284         emit Transfer(from, to, tokenId);
1285         _afterTokenTransfers(from, to, tokenId, 1);
1286     }
1287 
1288     /**
1289      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1290      */
1291     function safeTransferFrom(
1292         address from,
1293         address to,
1294         uint256 tokenId
1295     ) public virtual override {
1296         safeTransferFrom(from, to, tokenId, '');
1297     }
1298 
1299     /**
1300      * @dev Safely transfers `tokenId` token from `from` to `to`.
1301      *
1302      * Requirements:
1303      *
1304      * - `from` cannot be the zero address.
1305      * - `to` cannot be the zero address.
1306      * - `tokenId` token must exist and be owned by `from`.
1307      * - If the caller is not `from`, it must be approved to move this token
1308      * by either {approve} or {setApprovalForAll}.
1309      * - If `to` refers to a smart contract, it must implement
1310      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function safeTransferFrom(
1315         address from,
1316         address to,
1317         uint256 tokenId,
1318         bytes memory _data
1319     ) public virtual override {
1320         transferFrom(from, to, tokenId);
1321         if (to.code.length != 0)
1322             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1323                 revert TransferToNonERC721ReceiverImplementer();
1324             }
1325     }
1326 
1327     /**
1328      * @dev Hook that is called before a set of serially-ordered token IDs
1329      * are about to be transferred. This includes minting.
1330      * And also called before burning one token.
1331      *
1332      * `startTokenId` - the first token ID to be transferred.
1333      * `quantity` - the amount to be transferred.
1334      *
1335      * Calling conditions:
1336      *
1337      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1338      * transferred to `to`.
1339      * - When `from` is zero, `tokenId` will be minted for `to`.
1340      * - When `to` is zero, `tokenId` will be burned by `from`.
1341      * - `from` and `to` are never both zero.
1342      */
1343     function _beforeTokenTransfers(
1344         address from,
1345         address to,
1346         uint256 startTokenId,
1347         uint256 quantity
1348     ) internal virtual {}
1349 
1350     /**
1351      * @dev Hook that is called after a set of serially-ordered token IDs
1352      * have been transferred. This includes minting.
1353      * And also called after one token has been burned.
1354      *
1355      * `startTokenId` - the first token ID to be transferred.
1356      * `quantity` - the amount to be transferred.
1357      *
1358      * Calling conditions:
1359      *
1360      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1361      * transferred to `to`.
1362      * - When `from` is zero, `tokenId` has been minted for `to`.
1363      * - When `to` is zero, `tokenId` has been burned by `from`.
1364      * - `from` and `to` are never both zero.
1365      */
1366     function _afterTokenTransfers(
1367         address from,
1368         address to,
1369         uint256 startTokenId,
1370         uint256 quantity
1371     ) internal virtual {}
1372 
1373     /**
1374      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1375      *
1376      * `from` - Previous owner of the given token ID.
1377      * `to` - Target address that will receive the token.
1378      * `tokenId` - Token ID to be transferred.
1379      * `_data` - Optional data to send along with the call.
1380      *
1381      * Returns whether the call correctly returned the expected magic value.
1382      */
1383     function _checkContractOnERC721Received(
1384         address from,
1385         address to,
1386         uint256 tokenId,
1387         bytes memory _data
1388     ) private returns (bool) {
1389         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1390             bytes4 retval
1391         ) {
1392             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1393         } catch (bytes memory reason) {
1394             if (reason.length == 0) {
1395                 revert TransferToNonERC721ReceiverImplementer();
1396             } else {
1397                 assembly {
1398                     revert(add(32, reason), mload(reason))
1399                 }
1400             }
1401         }
1402     }
1403 
1404     // =============================================================
1405     //                        MINT OPERATIONS
1406     // =============================================================
1407 
1408     /**
1409      * @dev Mints `quantity` tokens and transfers them to `to`.
1410      *
1411      * Requirements:
1412      *
1413      * - `to` cannot be the zero address.
1414      * - `quantity` must be greater than 0.
1415      *
1416      * Emits a {Transfer} event for each mint.
1417      */
1418     function _mint(address to, uint256 quantity) internal virtual {
1419         uint256 startTokenId = _currentIndex;
1420         if (quantity == 0) revert MintZeroQuantity();
1421 
1422         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1423 
1424         // Overflows are incredibly unrealistic.
1425         // `balance` and `numberMinted` have a maximum limit of 2**64.
1426         // `tokenId` has a maximum limit of 2**256.
1427         unchecked {
1428             // Updates:
1429             // - `balance += quantity`.
1430             // - `numberMinted += quantity`.
1431             //
1432             // We can directly add to the `balance` and `numberMinted`.
1433             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1434 
1435             // Updates:
1436             // - `address` to the owner.
1437             // - `startTimestamp` to the timestamp of minting.
1438             // - `burned` to `false`.
1439             // - `nextInitialized` to `quantity == 1`.
1440             _packedOwnerships[startTokenId] = _packOwnershipData(
1441                 to,
1442                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1443             );
1444 
1445             uint256 toMasked;
1446             uint256 end = startTokenId + quantity;
1447 
1448             // Use assembly to loop and emit the `Transfer` event for gas savings.
1449             // The duplicated `log4` removes an extra check and reduces stack juggling.
1450             // The assembly, together with the surrounding Solidity code, have been
1451             // delicately arranged to nudge the compiler into producing optimized opcodes.
1452             assembly {
1453                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1454                 toMasked := and(to, _BITMASK_ADDRESS)
1455                 // Emit the `Transfer` event.
1456                 log4(
1457                     0, // Start of data (0, since no data).
1458                     0, // End of data (0, since no data).
1459                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1460                     0, // `address(0)`.
1461                     toMasked, // `to`.
1462                     startTokenId // `tokenId`.
1463                 )
1464 
1465                 for {
1466                     let tokenId := add(startTokenId, 1)
1467                 } iszero(eq(tokenId, end)) {
1468                     tokenId := add(tokenId, 1)
1469                 } {
1470                     // Emit the `Transfer` event. Similar to above.
1471                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1472                 }
1473             }
1474             if (toMasked == 0) revert MintToZeroAddress();
1475 
1476             _currentIndex = end;
1477         }
1478         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1479     }
1480 
1481     /**
1482      * @dev Mints `quantity` tokens and transfers them to `to`.
1483      *
1484      * This function is intended for efficient minting only during contract creation.
1485      *
1486      * It emits only one {ConsecutiveTransfer} as defined in
1487      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1488      * instead of a sequence of {Transfer} event(s).
1489      *
1490      * Calling this function outside of contract creation WILL make your contract
1491      * non-compliant with the ERC721 standard.
1492      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1493      * {ConsecutiveTransfer} event is only permissible during contract creation.
1494      *
1495      * Requirements:
1496      *
1497      * - `to` cannot be the zero address.
1498      * - `quantity` must be greater than 0.
1499      *
1500      * Emits a {ConsecutiveTransfer} event.
1501      */
1502     function _mintERC2309(address to, uint256 quantity) internal virtual {
1503         uint256 startTokenId = _currentIndex;
1504         if (to == address(0)) revert MintToZeroAddress();
1505         if (quantity == 0) revert MintZeroQuantity();
1506         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1507 
1508         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1509 
1510         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1511         unchecked {
1512             // Updates:
1513             // - `balance += quantity`.
1514             // - `numberMinted += quantity`.
1515             //
1516             // We can directly add to the `balance` and `numberMinted`.
1517             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1518 
1519             // Updates:
1520             // - `address` to the owner.
1521             // - `startTimestamp` to the timestamp of minting.
1522             // - `burned` to `false`.
1523             // - `nextInitialized` to `quantity == 1`.
1524             _packedOwnerships[startTokenId] = _packOwnershipData(
1525                 to,
1526                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1527             );
1528 
1529             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1530 
1531             _currentIndex = startTokenId + quantity;
1532         }
1533         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1534     }
1535 
1536     /**
1537      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1538      *
1539      * Requirements:
1540      *
1541      * - If `to` refers to a smart contract, it must implement
1542      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1543      * - `quantity` must be greater than 0.
1544      *
1545      * See {_mint}.
1546      *
1547      * Emits a {Transfer} event for each mint.
1548      */
1549     function _safeMint(
1550         address to,
1551         uint256 quantity,
1552         bytes memory _data
1553     ) internal virtual {
1554         _mint(to, quantity);
1555 
1556         unchecked {
1557             if (to.code.length != 0) {
1558                 uint256 end = _currentIndex;
1559                 uint256 index = end - quantity;
1560                 do {
1561                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1562                         revert TransferToNonERC721ReceiverImplementer();
1563                     }
1564                 } while (index < end);
1565                 // Reentrancy protection.
1566                 if (_currentIndex != end) revert();
1567             }
1568         }
1569     }
1570 
1571     /**
1572      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1573      */
1574     function _safeMint(address to, uint256 quantity) internal virtual {
1575         _safeMint(to, quantity, '');
1576     }
1577 
1578     // =============================================================
1579     //                        BURN OPERATIONS
1580     // =============================================================
1581 
1582     /**
1583      * @dev Equivalent to `_burn(tokenId, false)`.
1584      */
1585     function _burn(uint256 tokenId) internal virtual {
1586         _burn(tokenId, false);
1587     }
1588 
1589     /**
1590      * @dev Destroys `tokenId`.
1591      * The approval is cleared when the token is burned.
1592      *
1593      * Requirements:
1594      *
1595      * - `tokenId` must exist.
1596      *
1597      * Emits a {Transfer} event.
1598      */
1599     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1600         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1601 
1602         address from = address(uint160(prevOwnershipPacked));
1603 
1604         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1605 
1606         if (approvalCheck) {
1607             // The nested ifs save around 20+ gas over a compound boolean condition.
1608             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1609                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1610         }
1611 
1612         _beforeTokenTransfers(from, address(0), tokenId, 1);
1613 
1614         // Clear approvals from the previous owner.
1615         assembly {
1616             if approvedAddress {
1617                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1618                 sstore(approvedAddressSlot, 0)
1619             }
1620         }
1621 
1622         // Underflow of the sender's balance is impossible because we check for
1623         // ownership above and the recipient's balance can't realistically overflow.
1624         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1625         unchecked {
1626             // Updates:
1627             // - `balance -= 1`.
1628             // - `numberBurned += 1`.
1629             //
1630             // We can directly decrement the balance, and increment the number burned.
1631             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1632             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1633 
1634             // Updates:
1635             // - `address` to the last owner.
1636             // - `startTimestamp` to the timestamp of burning.
1637             // - `burned` to `true`.
1638             // - `nextInitialized` to `true`.
1639             _packedOwnerships[tokenId] = _packOwnershipData(
1640                 from,
1641                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1642             );
1643 
1644             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1645             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1646                 uint256 nextTokenId = tokenId + 1;
1647                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1648                 if (_packedOwnerships[nextTokenId] == 0) {
1649                     // If the next slot is within bounds.
1650                     if (nextTokenId != _currentIndex) {
1651                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1652                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1653                     }
1654                 }
1655             }
1656         }
1657 
1658         emit Transfer(from, address(0), tokenId);
1659         _afterTokenTransfers(from, address(0), tokenId, 1);
1660 
1661         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1662         unchecked {
1663             _burnCounter++;
1664         }
1665     }
1666 
1667     // =============================================================
1668     //                     EXTRA DATA OPERATIONS
1669     // =============================================================
1670 
1671     /**
1672      * @dev Directly sets the extra data for the ownership data `index`.
1673      */
1674     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1675         uint256 packed = _packedOwnerships[index];
1676         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1677         uint256 extraDataCasted;
1678         // Cast `extraData` with assembly to avoid redundant masking.
1679         assembly {
1680             extraDataCasted := extraData
1681         }
1682         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1683         _packedOwnerships[index] = packed;
1684     }
1685 
1686     /**
1687      * @dev Called during each token transfer to set the 24bit `extraData` field.
1688      * Intended to be overridden by the cosumer contract.
1689      *
1690      * `previousExtraData` - the value of `extraData` before transfer.
1691      *
1692      * Calling conditions:
1693      *
1694      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1695      * transferred to `to`.
1696      * - When `from` is zero, `tokenId` will be minted for `to`.
1697      * - When `to` is zero, `tokenId` will be burned by `from`.
1698      * - `from` and `to` are never both zero.
1699      */
1700     function _extraData(
1701         address from,
1702         address to,
1703         uint24 previousExtraData
1704     ) internal view virtual returns (uint24) {}
1705 
1706     /**
1707      * @dev Returns the next extra data for the packed ownership data.
1708      * The returned result is shifted into position.
1709      */
1710     function _nextExtraData(
1711         address from,
1712         address to,
1713         uint256 prevOwnershipPacked
1714     ) private view returns (uint256) {
1715         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1716         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1717     }
1718 
1719     // =============================================================
1720     //                       OTHER OPERATIONS
1721     // =============================================================
1722 
1723     /**
1724      * @dev Returns the message sender (defaults to `msg.sender`).
1725      *
1726      * If you are writing GSN compatible contracts, you need to override this function.
1727      */
1728     function _msgSenderERC721A() internal view virtual returns (address) {
1729         return msg.sender;
1730     }
1731 
1732     /**
1733      * @dev Converts a uint256 to its ASCII string decimal representation.
1734      */
1735     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1736         assembly {
1737             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1738             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1739             // We will need 1 32-byte word to store the length,
1740             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1741             str := add(mload(0x40), 0x80)
1742             // Update the free memory pointer to allocate.
1743             mstore(0x40, str)
1744 
1745             // Cache the end of the memory to calculate the length later.
1746             let end := str
1747 
1748             // We write the string from rightmost digit to leftmost digit.
1749             // The following is essentially a do-while loop that also handles the zero case.
1750             // prettier-ignore
1751             for { let temp := value } 1 {} {
1752                 str := sub(str, 1)
1753                 // Write the character to the pointer.
1754                 // The ASCII index of the '0' character is 48.
1755                 mstore8(str, add(48, mod(temp, 10)))
1756                 // Keep dividing `temp` until zero.
1757                 temp := div(temp, 10)
1758                 // prettier-ignore
1759                 if iszero(temp) { break }
1760             }
1761 
1762             let length := sub(end, str)
1763             // Move the pointer 32 bytes leftwards to make room for the length.
1764             str := sub(str, 0x20)
1765             // Store the length.
1766             mstore(str, length)
1767         }
1768     }
1769 }
1770 // File: DustyLand.sol
1771 
1772 
1773 pragma solidity >=0.7.0 <0.9.0;
1774 
1775 
1776 
1777 
1778 
1779 contract DustyLand is ERC721A, Ownable, ReentrancyGuard {
1780 
1781     bool public paused = true;
1782     bool public revealed = false;
1783 
1784     uint256 public cost = 0.15 ether; //0.15WL 0.2P
1785     uint256 public maxSupply = 2000; //2000
1786     uint256 public constant maxMintAmountPerTx = 5; 
1787     uint256 public mode = 0; 
1788 
1789     bytes32 public merkleRoot;
1790 
1791     address public immutable proxyRegistryAddress = address(0xa5409ec958C83C3f309868babACA7c86DCB077c1);
1792     //Rinkeby: 0xF57B2c51dED3A29e6891aba85459d600256Cf317
1793     //Mainnet: 0xa5409ec958C83C3f309868babACA7c86DCB077c1
1794 
1795     mapping(address => uint256) public ClaimedWhitelist;
1796 
1797     string public hiddenuri = "ipfs://QmUqKwLMfkinCNUwyMKSntHrD7EMpU2pMK7wNmvFC4Yr13/hidden_metadata.json";
1798     string public uri;
1799 
1800     constructor() ERC721A("DustyLand", "DUSTYLAND") ReentrancyGuard() {
1801         _mint(msg.sender, 1);
1802     }
1803 
1804     //modifiers
1805     modifier mintCompliance(uint256 _mintAmount) {
1806         require(_mintAmount > 0 && _mintAmount < maxMintAmountPerTx+1, "Invalid mint amount");
1807         require(totalSupply() + _mintAmount < maxSupply+1, "Exceeds Max Supply");
1808         _;
1809     }
1810 
1811     function _startTokenId() internal view virtual override returns (uint256) {
1812         return 1;
1813     }
1814 
1815     //mint
1816     function mint(uint256 quantity, bytes32[] calldata proof) external payable mintCompliance(quantity) nonReentrant {
1817         require(!paused, "Contract paused");
1818         require(msg.value > cost * quantity -1, "Insufficient funds");
1819 
1820         if(mode == 0) {
1821             require(ClaimedWhitelist[msg.sender] + quantity < 3, "Exceeds whitelist allowance");
1822             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1823             require(MerkleProof.verify(proof, merkleRoot, leaf), "Verification failed");
1824             ClaimedWhitelist[msg.sender] += quantity;
1825         }
1826         _mint(msg.sender, quantity);
1827     }
1828 
1829     function batch_mint(uint256 quantity) external onlyOwner {
1830         require(totalSupply() + quantity < maxSupply+1, "Exceeds Max Supply");
1831         _mint(msg.sender, quantity);
1832     }
1833 
1834     //Get
1835     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1836         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1837 
1838 
1839         if(!revealed) {
1840             return bytes(hiddenuri).length != 0 ? hiddenuri : '';
1841         }
1842         else {
1843             string memory baseURI = "";
1844             baseURI = _baseURI();
1845             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
1846         }
1847 
1848     }
1849     function _baseURI() internal view virtual override returns (string memory) {
1850         return uri;
1851     }
1852 
1853     //Set
1854     function set_uri(string calldata new_uri) external onlyOwner {
1855         uri=new_uri;
1856     }
1857 
1858     function set_hiddenuri(string calldata new_hiddenuri) external onlyOwner {
1859         hiddenuri=new_hiddenuri;
1860     }
1861 
1862     function set_cost(uint256 new_cost) external onlyOwner {
1863         cost = new_cost;
1864     }
1865 
1866     function set_maxSupply(uint256 new_maxSupply) external onlyOwner {
1867         maxSupply = new_maxSupply;
1868     }
1869 
1870     function toggle_paused() external onlyOwner {
1871         if(paused) {
1872             paused = false;
1873         }
1874         else {
1875             paused = true;
1876         }
1877     }
1878 
1879     function toggle_revealed() external onlyOwner {
1880         if(revealed) {
1881             revealed = false;
1882         }
1883         else {
1884             revealed = true;
1885         }
1886     }
1887 
1888     function toggle_mode() external onlyOwner {
1889         mode = (mode+1)%2;
1890         if(mode == 0) {
1891             cost = 0.15 ether; //whitelist price
1892         }
1893         else {
1894             cost = 0.2 ether; //pub price
1895         }
1896     }
1897 
1898     function set_merkleroot(bytes32 new_root) external onlyOwner {
1899         merkleRoot = new_root;
1900     }
1901 
1902     function withdraw() public payable onlyOwner {
1903         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1904         require(os);
1905     }
1906 
1907     function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
1908         OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(proxyRegistryAddress);
1909         if(address(proxyRegistry.proxies(_owner)) == operator) {
1910             return true;
1911         }
1912         return super.isApprovedForAll(_owner, operator);
1913     }
1914 
1915     function kill_() external onlyOwner {
1916         address payable owner_payable = payable(owner());
1917         selfdestruct(owner_payable);
1918     }
1919 
1920 }
1921 
1922 
1923 contract OwnableDelegateProxy {}
1924 contract OpenSeaProxyRegistry {
1925     mapping(address => OwnableDelegateProxy) public proxies;
1926 }